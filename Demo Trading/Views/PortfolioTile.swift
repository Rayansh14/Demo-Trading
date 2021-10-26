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
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("Avg: \(stock.avgPriceBought.withCommas(withRupeeSymbol: false))")
                        .font(.system(size: 15))
                        .foregroundColor(Color("Gray"))
                    
                    Text(stock.stockSymbol)
                        .font(.system(size: 20))
                        .frame(height: 32)
                    
                    Text("Qty: \(stock.numberOfShares)")
                        .font(.system(size: 15))
                        .foregroundColor(Color("Gray"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(String(format: "%.2f", profitLossPercent))%")
                        .foregroundColor(profitLoss >= 0 ? .green : .red)
                        .font(.system(size: 15))
                    
                    Text("\(profitLoss >= 0 ? "+" : "")\(profitLoss.withCommas(withRupeeSymbol: false))")
                        .font(.system(size: 20))
                        .frame(height: 32)
                        .foregroundColor(profitLoss >= 0 ? .green : .red)
                    
                    HStack(spacing: 0) {
                        Text("LTP: \(stock.lastPrice.withCommas(withRupeeSymbol: false))")
                            .font(.system(size: 15))
                            .foregroundColor(Color("Gray"))
                        Text(" (\(stock.dayChange >= 0 ? "+" : "")\(String(format: "%.2f", stock.dayPChange))%)")
                            .font(.system(size: 16))
                            .foregroundColor(stock.dayChange >= 0 ? .green : .red)
                    }
                }
                
            }
            .padding(.horizontal)
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