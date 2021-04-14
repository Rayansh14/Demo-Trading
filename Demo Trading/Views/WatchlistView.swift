//
//  WatchlistView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct WatchlistView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        ScrollView {
            VStack {
                if data.stockQuotes.count == 0 {
                    Text("No quotes to display")
                        .bold()
                        .padding()
                        .padding(.bottom, 50)
                        .multilineTextAlignment(.center)
                } else {
                    ForEach(data.stockQuotes) { stockQuote in
                        WatchlistTileView(stockQuote: stockQuote)
                    }
                }
            }
        }
    }
}

struct WatchlistTileView: View {
    
    @State var stockQuote: StockQuote
    
    var body: some View {
        HStack {
            Spacer()
            Text(stockQuote.symbol)
                .padding()
            Spacer()
        }
    }
}

struct WatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WatchlistView()
            WatchlistTileView(stockQuote: testStockQuote)
        }
    }
}
