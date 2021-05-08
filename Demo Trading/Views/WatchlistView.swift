//
//  WatchlistView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct WatchlistView: View {
    
    @ObservedObject var data = DataController.shared
    @State var showSheet = false
    let timer = Timer.publish(every: 30, tolerance: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
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
                                        Button(action: {showSheet = true}) {
                                            WatchlistTileView(stockQuote: stockQuote)
                                        }
                                        .sheet(isPresented: $showSheet) {
                                            StockDetailView(stockQuote: stockQuote)
                                        }
                                    }
                                }
                            }
                            Divider()
                        }
                    }
                }
                .navigationTitle("Watchlist")
                .navigationBarItems(leading: Button(action: {
                    data.resetAll()
                }) {
                    Image(systemName: "0.square")
                }, trailing: Button(action: {
                    if data.getMarketStatus() {
                        data.getStocksData()
                    }
                }) {
                    Image(systemName: "gobackward")
                })
                VStack {
                    Spacer()
                    ErrorTileView(error: data.errorMessage)
                        .opacity(data.showError ? 1.0 : 0.0)
                        .animation(.easeInOut)
                        .padding(.bottom)
                }
            }
        }
        .onReceive(timer, perform: { _ in
            if data.getMarketStatus() {
                data.getStocksData()
            }
        })
    }
}

struct WatchlistTileView: View {
    
    var stockQuote: StockQuote
    
    var body: some View {
        ZStack {
            Color("White Black")
            VStack {
                //                                Divider()
                HStack {
                    Text(stockQuote.symbol)
                        .padding(15)
                        .font(.system(size: 20))
                    Spacer()
                    VStack {
                        Text(String(format: "%.2f", stockQuote.lastPrice))
                            .padding(.horizontal)
                            .font(.system(size: 18))
                        Text("\(String(format: "%.2f", stockQuote.pChange))%")
                            .padding(.horizontal)
                            .font(.system(size: 14))
                    }
                }
                .foregroundColor(stockQuote.pChange >= 0 ? .green : .red)
                //                Divider()
            }
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


