//
//  PortfolioTileView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 06/05/21.
//

import SwiftUI

struct PortfolioTileView: View {
    
    @ObservedObject var data = DataController.shared
    var stockOwned = StockOwned()
    var stockQuote = StockQuote()
    var profitLoss: Double {
        return (stockQuote.displayPrice - stockOwned.avgPriceBought) * Double(stockOwned.numberOfShares)
    }
    var profitLossPercent: Double {
        return profitLoss / stockOwned.investedAmt * 100
    }
    //    @Binding var refresh: Bool
    
    init(stockSymbol: String, portfolioType: PortfolioType) {
        stockQuote = data.getStockQuote(stockSymbol: stockSymbol)
        if let owned = data.getStockOwned(stockSymbol: stockSymbol, portfolioType: portfolioType) {
            stockOwned = owned
        }
    }
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Avg: \(stockOwned.avgPriceBought.withCommas())")
                    .font(.custom("Poppins-Light", size: 13.5))
                    .foregroundColor(Color("Gray"))
                
                Text(stockOwned.stockSymbol)
                    .font(.custom("Poppins-Light", size: 17))
                
                Text("Qty: \(stockOwned.numberOfShares)")
                    .font(.custom("Poppins-Light", size: 13.5))
                    .foregroundColor(Color("Gray"))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text("\(profitLossPercent.withCommas())%")
                    .foregroundColor(profitLoss >= 0 ? .green : .red)
                    .font(.custom("Poppins-Light", size: 13.5))
                
                Text("\(profitLoss >= 0 ? "+" : "")\(profitLoss.withCommas())")
                    .font(.custom("Poppins-Light", size: 17))
                    .foregroundColor(profitLoss >= 0 ? .green : .red)
                
                HStack(spacing: 0) {
                    Text("LTP: \(stockQuote.displayPrice.withCommas())")
                        .foregroundColor(Color("Gray"))
                    Text(" (\(stockQuote.change >= 0 ? "+" : "")\(stockQuote.pChange.withCommas())%)")
                        .foregroundColor(stockQuote.change >= 0 ? .green : .red)
                }
                .font(.custom("Poppins-Light", size: 13.5))
            }
            
        }
        .padding(.horizontal)
        .foregroundColor(Color("Black White")) // without this, text colour is blue
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
