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
    @Binding var refresh: Bool
    
    var body: some View {
        NavigationLink(destination: StockDetailView(stockSymbol: stock.stockSymbol, isFullScreen: true)) {
            HStack {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Avg: \(stock.avgPriceBought.withCommas())")
                        .font(.custom("Poppins-Light", size: 13.5))
                        .foregroundColor(Color("Gray"))
                    
                    Text(stock.stockSymbol)
                        .font(.custom("Poppins-Light", size: 17))
                    
                    Text("Qty: \(stock.numberOfShares)")
                        .font(.custom("Poppins-Light", size: 13.5))
                        .foregroundColor(Color("Gray"))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text("\(String(format: "%.2f", profitLossPercent))%")
                        .foregroundColor(profitLoss >= 0 ? .green : .red)
                        .font(.custom("Poppins-Light", size: 13.5))
                    
                    Text("\(profitLoss >= 0 ? "+" : "")\(profitLoss.withCommas())")
                        .font(.custom("Poppins-Light", size: 17))
                        .foregroundColor(profitLoss >= 0 ? .green : .red)
                    
                    HStack(spacing: 0) {
                        Text("LTP: \(stock.lastPrice.withCommas())")
                            .foregroundColor(Color("Gray"))
                        Text(" (\(stock.dayChange >= 0 ? "+" : "")\(String(format: "%.2f", stock.dayPChange))%)")
                            .foregroundColor(stock.dayChange >= 0 ? .green : .red)
                    }
                    .font(.custom("Poppins-Light", size: 13.5))
                }
                
            }
            .padding(.horizontal)
            .foregroundColor(Color("Black White")) // without this, text colour is blue
        }
        .onAppear(perform: {
            updateProfitLoss()
            refresh.toggle()
        })
    }
    
    func updateProfitLoss() {
        profitLoss = (stock.lastPrice * Double(stock.numberOfShares)) - (stock.avgPriceBought * Double(stock.numberOfShares))
        profitLossPercent = profitLoss/(stock.avgPriceBought * Double(stock.numberOfShares)) * 100
    }
}


struct PortfolioTileView_Previews: PreviewProvider {
//    @State var refresh = false
    static var previews: some View {
        Group {
//            PortfolioTileView(stock: testStockOwned, refresh: $refresh)
//                .preferredColorScheme(.dark)
        }
    }
}
