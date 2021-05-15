//
//  PortfolioTileView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 06/05/21.
//

import SwiftUI

struct PortfolioTileView: View {
    
    var stock: StockOwned
    @State var profitLoss: Double = 0.0
    @State var profitLossPercent: Double = 0.0
    @ObservedObject var data = DataController.shared
    var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationLink(destination: StockDetailView(stockQuote: data.getStockQuote(stockSymbol: stock.stockSymbol), showTitle: true)) {
            HStack {
                
                VStack {
                    HStack {
                        Text("Avg: \(String(format: "%.2f", stock.avgPriceBought))")
                            .font(.system(size: 16))
                        Spacer()
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0.2002688944, green: 0.2002688944, blue: 0.2002688944, alpha: 1)))
                    HStack {
                        Text(stock.stockSymbol)
                            .font(.system(size: 21))
                            .frame(height: 32)
                        Spacer()
                    }
                    HStack {
                        Text("Qty: \(stock.numberOfShares)")
                            .font(.system(size: 16))
                        Spacer()
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0.2002688944, green: 0.2002688944, blue: 0.2002688944, alpha: 1)))
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        Text("\(String(format: "%.2f", profitLossPercent))%")
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                            .font(.system(size: 16))
                    }
                    HStack {
                        Spacer()
                        Text("\(profitLoss >= 0 ? "+" : "") \(String(format: "%.2f", profitLoss))")
                            .font(.system(size: 22))
                            .frame(height: 32)
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                    }
                    
                    HStack {
                        Spacer()
                        Text("LTP. \(String(format: "%.2f", stock.lastPrice))")
                            .font(.system(size: 16))
                            .foregroundColor(Color(#colorLiteral(red: 0.2002688944, green: 0.2002688944, blue: 0.2002688944, alpha: 1)))
                    }
                }
                .padding(.horizontal)
                
            }
            .foregroundColor(Color("Black White")) // without this, text colour is blue
        }
        .onAppear(perform: {
            updateProfitLoss()
        })
        .onReceive(timer, perform: { _ in
            updateProfitLoss()
        })
    }
    
    func updateProfitLoss() {
        profitLoss = (stock.lastPrice * Double(stock.numberOfShares)) - (stock.avgPriceBought * Double(stock.numberOfShares))
        profitLossPercent = profitLoss/(stock.avgPriceBought * Double(stock.numberOfShares)) * 100
    }
}


struct PortfolioTileView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioTileView(stock: testStockOwned)
    }
}
