//
//  PortfolioTileView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 06/05/21.
//

import SwiftUI

struct PortfolioTileView: View {
    
    var stock: StockOwned
    @State private var profitLoss: Double = 0.0
    @State private var profitLossPercent: Double = 0.0
    @ObservedObject var data = DataController.shared
    var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationLink(destination: StockDetailView(stockSymbol: stock.stockSymbol, isFullScreen: true)) {
            HStack {
                
                VStack(spacing: 3) {
                    HStack {
                        Text("Avg: \(String(format: "%.2f", stock.avgPriceBought))")
                            .font(.system(size: 15))
                        Spacer()
                    }
                    .foregroundColor(Color("Gray"))
                    HStack {
                        Text(stock.stockSymbol)
                            .font(.system(size: 20))
                            .frame(height: 32)
                        Spacer()
                    }
                    HStack {
                        Text("Qty: \(stock.numberOfShares)")
                            .font(.system(size: 15))
                        Spacer()
                    }
                    .foregroundColor(Color("Gray"))
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 3) {
                    HStack {
                        Spacer()
                        Text("\(String(format: "%.2f", profitLossPercent))%")
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                            .font(.system(size: 15))
                    }
                    HStack {
                        Spacer()
                        Text("\(profitLoss >= 0 ? "+" : "")\(String(format: "%.2f", profitLoss))")
                            .font(.system(size: 20))
                            .frame(height: 32)
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                    }
                    
                    HStack {
                        Spacer()
                        
                        HStack(spacing: 0) {
                        Text("LTP: \(String(format: "%.2f", stock.lastPrice))")
                            .font(.system(size: 15))
                            .foregroundColor(Color("Gray"))
                        Text(" (\(stock.dayChange >= 0 ? "+" : "")\(String(format: "%.2f", stock.dayPChange))%)")
                            .font(.system(size: 16))
                            .foregroundColor(stock.dayChange >= 0 ? .green : .red)
                        }
                    }
                }
                
                .padding(.trailing)
                
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
