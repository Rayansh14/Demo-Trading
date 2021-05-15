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
    @State var selectedStock = StockQuote()
    @State var offset = CGSize(width: 0, height: 750)
    private let timer = Timer.publish(every: 30, tolerance: 5, on: .main, in: .common).autoconnect()
    
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
                            ForEach(data.userStocksOrder, id: \.self) { stock in
                                ForEach(data.stockQuotes) { stockQuote in
                                    if stockQuote.symbol == stock {
                                        Divider()
                                        Button(action: {
                                            offset = CGSize.zero
                                            showSheet = true
                                            selectedStock = stockQuote
                                        }) {
                                            WatchlistTileView(stockQuote: stockQuote)
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
                
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(#colorLiteral(red: 0.9574782252, green: 0.9574782252, blue: 0.9574782252, alpha: 1)))
                                .frame(height: 55)
                                .cornerRadius(8)
                            HStack {
                                Text(selectedStock.symbol)
                                    .font(.title)
                                    .padding(.horizontal)
                                Spacer()
                                
                            }
                        }
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if self.offset.height > -1.0 {
                                            self.offset = gesture.translation
                                        }
                                    }
                                    .onEnded { _ in
                                        if offset.height > 20 {
                                            offset.height = 750
                                            showSheet = false
                                            hideKeyboard()
                                        } else {
                                            offset.height = 0
                                        }
                                    }
                            )
                        NavigationView {
                            StockDetailView(stockQuote: selectedStock, showTitle: false)
                        }
                    }
                    .frame(height: 400)
                }
                .opacity(showSheet ? 1 : 0)
                .offset(y: offset.height)
                .animation(.easeInOut(duration: 0.6))
            }
        }
        .onReceive(timer, perform: { _ in
            if data.getMarketStatus() {
                data.getStocksData()
            }
            PortfolioListView(portfolioType: .holdings).updateAllPortfolioData()
            PortfolioListView(portfolioType: .positions).updateAllPortfolioData()
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


