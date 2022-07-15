//
//  WatchlistTileNew.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 03/06/22.
//

import SwiftUI

struct WatchlistTileNew: View {
    
    var stockQuote = StockQuote()
    @ObservedObject var data = DataController.shared
    
    init(stockSymbol: String) {
        self.stockQuote = data.getStockQuote(stockSymbol: stockSymbol)
    }
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(stockQuote.symbol)
                    .font(.system(size: 18.5))
                    .bold()
                    .fontWeight(.bold)
                Text(codes[stockQuote.symbol] ?? stockQuote.symbol.capitalized)
//                    .font(.caption)
                    .font(.custom("Poppins-Regular", size: 12))
            }
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                Text(Int(stockQuote.displayPrice).description)
                    .font(.system(size: 18.5))
                    .fontWeight(.bold)
                +
                Text(".\(String(format: "%.2f", stockQuote.displayPrice).components(separatedBy: ".")[1])")
                    .font(.system(size: 16.5))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                Text("\(stockQuote.change < 0 ? "" : "+")\(stockQuote.pChange.withCommas())%")
//                    .font(Font.footnote)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(stockQuote.pChange >= 0 ? .green : .red)
//                    .fontWeight(.semibold)
            }
        }
        
//        #imageLiteral(
        .padding(.horizontal, 15)
        .padding(.vertical, 12)
        .background(Color("Light Gray"))
        
        .cornerRadius(15)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct WatchlistTileNew_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WatchlistTileNew(stockSymbol: "Reliance")
//                .preferredColorScheme(.dark)
            WatchlistTileView(stockSymbol: "Reliance")
                .padding()
        }
    }
}
