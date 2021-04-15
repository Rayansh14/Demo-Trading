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
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if data.stockQuotes.count == 0 {
                        Text("Loading...")
                            .bold()
                            .padding()
                            .padding(.bottom, 50)
                    } else {
                        ForEach(data.stockQuotesOrder, id: \.self) { stock in
                            ForEach(data.stockQuotes) { stockQuote in
                                if stockQuote.symbol == stock {
                                    Divider()
                                    NavigationLink(destination: StockDetailView(stockQuote: stockQuote)) {
                                    WatchlistTileView(stockQuote: stockQuote)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Watchlist")
        }
    }
}

struct WatchlistTileView: View {
    
    @State var stockQuote: StockQuote
    
    var body: some View {
        ZStack {
            Color("White Black")
            HStack {
                Text(stockQuote.symbol)
                    .padding(15)
                Spacer()
                Text(String(stockQuote.lastPrice))
                    .padding()
            }
            .foregroundColor(stockQuote.pChange >= 0 ? .green : .red)
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
