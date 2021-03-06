//
//  BarChart.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 13/12/21.
//

// number of stocks in holdings
// day profit/loss in each stock
//

import SwiftUI

struct BarChart: View {
    
    @ObservedObject var data = DataController.shared
    @State var focus: String? = nil
    @State var infoOffset: CGSize = CGSize.zero
    @State var dayProfitLoss = 0.0
    @Binding var refresh: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 8) {
                ForEach(data.holdings) { stock in
                    BarView(stockSymbol: stock.stockSymbol, height: getHeight(dayProfitLoss: getDayProfitLoss(stockSymbol: stock.stockSymbol)), width: getWidth(), dayProfitLoss: getDayProfitLoss(stockSymbol: stock.stockSymbol), refresh: $refresh, focus: $focus, focusDayProfitLoss: $dayProfitLoss, infoOffset: $infoOffset)
                }
            }
            if refresh || !refresh {}

            Rectangle()
                .frame(height: 1)

            VStack {
                Text(focus ?? "")
                    .animation(.none, value: focus)
                Text("\(dayProfitLoss < 0 ? "" : "+")\(dayProfitLoss.withCommas())")
                    .foregroundColor(dayProfitLoss < 0 ? .red : .green)
            }
            .font(.custom("Poppins-Light", size: 16.5))
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black)
            )
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color("Light Gray"))
            )
            .animation(.none, value: infoOffset)
            .offset(x: infoOffset.width, y: infoOffset.height)
            .opacity(focus != nil ? 1 : 0)
            
        }
        .padding(.vertical, 100)
    }
    
    func getDayProfitLoss(stockSymbol: String) -> Double {
        if let num_shares = data.getStockOwned(stockSymbol: stockSymbol, portfolioType: .holdings)?.numberOfShares {
            let change = data.getStockQuote(stockSymbol: stockSymbol).change
            return Double(num_shares) * change
        }
        return 0
    }
    
    func getWidth() -> CGFloat {
        return min(25, (UIScreen.main.bounds.width-CGFloat(data.holdings.count)*8.0)/CGFloat(data.holdings.count))
    }

    func getHeight(dayProfitLoss: Double) -> CGFloat {
        if data.holdings.count > 0 {
            let maxStockChange = data.holdings.sorted { one, two in
                return abs(getDayProfitLoss(stockSymbol: one.stockSymbol)) > abs(getDayProfitLoss(stockSymbol: two.stockSymbol)) // returns list sorted from most absolute change to least absolute change
            }[0]
            
            let ratio = getDayProfitLoss(stockSymbol: maxStockChange.stockSymbol) / 150
            if ratio != 0 {
                return abs(dayProfitLoss/ratio)
            }
        }
        return 0
    }
}

struct BarView: View {

    var stockSymbol: String
    var height: CGFloat
    var width: CGFloat
    var dayProfitLoss: Double
    @Binding var refresh: Bool
    @Binding var focus: String?
    @Binding var focusDayProfitLoss: Double
    @Binding var infoOffset: CGSize
    @ObservedObject var data = DataController.shared

    var body: some View {

        ZStack {

            Rectangle()
                .foregroundColor(dayProfitLoss > 0 ? .green : .red)
                .frame(width: width, height: height)
                .cornerRadius(width, corners: dayProfitLoss > 0 ? [.topLeft, .topRight] : [.bottomLeft, .bottomRight])
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { gesture in
                            // startLocation is 0 at the top of particular view
                            if dayProfitLoss < 0 {
                                infoOffset.height = gesture.startLocation.y - 75
                            } else {
                                infoOffset.height = gesture.startLocation.y - height - 75
                            }
                            withAnimation(.spring(blendDuration: 0.1)) {
                                focusDayProfitLoss = dayProfitLoss
                                infoOffset.width = getXOffset()
                                focus = stockSymbol
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.spring(blendDuration: 0.1)) {
                                focus = nil
                            }
                        }
                )
                .offset(y: dayProfitLoss > 0 ? -height/2 : height/2)
        }
    }

    func getXOffset() -> CGFloat {
        if let index = data.holdings.firstIndex(where: { loopingStockOwned in
            loopingStockOwned.stockSymbol == stockSymbol
        }) {
            let i = ((CGFloat(index) + 0.5) - CGFloat(data.holdings.count)/2) * (width + 8)
            print(i)
            let width = UIScreen.main.bounds.width-125
            if abs(i) > width/2 {
                if i < 0 {
                    return -width/2
                }
                return width/2
            }
            return i
        }
        return 0
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//                        BarView(stockSymbol: "RELIANCE", dayProfitLoss: 127.3, height: 127.3, width: 30)
//            BarChart(, refresh: /)
        }
    }
}
