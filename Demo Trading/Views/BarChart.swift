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
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .frame(height: 1)
            
            HStack {
                ForEach(data.holdings) { stock in
                    BarView(stockSymbol: stock.stockSymbol, dayProfitLoss: stock.dayProfitLoss, height: getHeight(dayProfitLoss: stock.dayProfitLoss), width: getWidth())
                }
            }
            
        }
        .padding(.vertical, 100)
    }
    
    func getWidth() -> CGFloat {
        return min(25, (UIScreen.main.bounds.width-50)/CGFloat(data.holdings.count))
    }
    
    func getHeight(dayProfitLoss: Double) -> CGFloat {
        if data.holdings.count > 0 {
            let ratio = data.holdings.sorted { one, two in
                return abs(one.dayProfitLoss) > abs(two.dayProfitLoss) // returns list sorted from most absolute change to least absolute change
            }[0].dayProfitLoss / 150
            if ratio != 0 {
                return abs(dayProfitLoss/ratio)
            }
        }
        return 0
    }
}

struct BarView: View {
    
    @State private var infoOffsetY: CGFloat = 0
    var stockSymbol: String
    var dayProfitLoss: Double
    var height: CGFloat
    var width: CGFloat
    @State private var focus: Bool = false
    
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
                                infoOffsetY = gesture.startLocation.y - 75
                            } else {
                                infoOffsetY = gesture.startLocation.y - height - 75
                            }
                            withAnimation(.spring()) {
                                focus = true
                            }
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                focus = false
                            }
                        }
                )
                .offset(y: dayProfitLoss > 0 ? -height/2 - 1 : height/2 + 1)
            
            
            if focus {
                VStack {
                    Text(stockSymbol)
                    Text("\(dayProfitLoss < 0 ? "" : "+")\(dayProfitLoss.withCommas())")
                        .foregroundColor(dayProfitLoss < 0 ? .red : .green)
                }
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.black)
                )
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color("Light Gray"))
                )
                .animation(.none, value: infoOffsetY)
                .offset(y: infoOffsetY)
            }
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //            BarView(stockSymbol: "RELIANCE", dayProfitLoss: 127.3, height: 127.3, width: 30)
            BarChart()
        }
    }
}
