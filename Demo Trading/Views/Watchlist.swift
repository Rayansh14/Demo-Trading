//
//  WatchlistView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI
import iActivityIndicator

struct WatchlistView: View {
    
    @ObservedObject var data = DataController.shared
    @State private var showSheet = false
    @State private var selectedStock = StockQuote()
    @State private var sheetOffset = CGSize(width: 0, height: 750)
    @State private var isAdding = false
    @State private var searchText = ""
    let timer = Timer.publish(every: 25, tolerance: 5, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    SearchBar(placeholderText: "Add stocks...", searchText: $searchText, isEditing: $isAdding, showSheet: $showSheet, sheetOffset: $sheetOffset)
                    
                    if !(isAdding) {
                        if data.userStocksOrder.count < 1 {
                            ZStack {
                                VStack {
                                    Image("watchlist")
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Color("Blue"))
                                        .opacity(colorScheme == ColorScheme.light ? 0.15 : 0.25)
                                        .padding(40)
                                }
                                VStack {
                                    Spacer()
                                    Text("Howdy!")
                                        .font(.title3)
                                    Text("Welcome to Demo Trading! To get started, tap on the light bulb in the top left corner. ↖")
                                    //                                    Text("Welcome to Demo Trading! To begin, add a stock to your watchlist using the search bar above 👆. Tap on it and select buy to buy that stock. You have been given ₹ 1,00,000 in fantasy money to buy stocks of your choosing! \nBest of luck and happy trading!")
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                            }
                        } else if data.stockQuotes.count == 0 {
                            VStack {
                                Spacer()
                                ZStack(alignment: .center) {
                                    Text("Loading...")
                                        .font(.title)
                                    iActivityIndicator(style: .arcs(count: 5, width: 5, spacing: 3))
                                        .padding(50)
                                        .foregroundColor(Color("Blue"))
                                }
                                Spacer()
                            }
                            
                        } else {
                            ZStack {
                                if data.userStocksOrder.count < 2 {
                                    VStack {
                                        Image("watchlist")
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color("Blue"))
                                            .opacity(0.9)
                                            .padding(40)
                                    }
                                }
                                List {
                                    ForEach(data.userStocksOrder, id: \.self) { stock in
                                        let stockQuote = data.getStockQuote(stockSymbol: stock)
                                        Button(action: {
                                            sheetOffset = CGSize.zero
                                            showSheet = true
                                            selectedStock = stockQuote
                                        }) {
                                            WatchlistTileView(stockQuote: stockQuote)
                                        }
                                    }
                                    .onDelete { indexSet in
                                        delete(at: indexSet)
                                    }
                                }
                                .listStyle(PlainListStyle())
                            }
                        }
                        
                    } else {
                        List(data.stockQuotes.filter { searchText.isEmpty ? true : $0.symbol.contains(searchText.filter {!$0.isWhitespace}) }) { stock in
                            HStack {
                                Text(stock.symbol)
                                Spacer()
                                Button(action: {
                                    if data.userStocksOrder.contains(stock.symbol) {
                                        d2(symbol: stock.symbol)
                                    } else {
                                        if data.userStocksOrder.count < 50 {
                                            data.userStocksOrder.append(stock.symbol)
                                        }
                                    }
                                    
                                    data.saveData()
                                }) {
                                    if data.userStocksOrder.contains(stock.symbol) {
                                        Image(systemName: "hand.thumbsup.fill")
                                            .imageScale(.large)
                                    } else {
                                        Image(systemName: "plus.square")
                                            .imageScale(.large)
                                    }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                
                VStack(spacing: 0) {
                    Spacer() // the spacer pushes the half sheet to the bottom of the phone
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color("Light Gray"))
                                .frame(height: 55)
                                .cornerRadius(10)
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
                                    if self.sheetOffset.height > -1.0 {
                                        self.sheetOffset = gesture.translation
                                    }
                                }
                                .onEnded { _ in
                                    if sheetOffset.height > 20 {
                                        sheetOffset.height = 750
                                        showSheet = false
                                        
                                    } else {
                                        sheetOffset.height = 0
                                    }
                                }
                        )
                        NavigationView {
                            StockDetailView(stockSymbol: selectedStock.symbol, isFullScreen: false)
                                .animation(.none, value: sheetOffset)
                        }
                    }
                    .frame(height: 350)
                }
                .opacity(showSheet ? 1 : 0)
                .offset(y: sheetOffset.height)
                .animation(.easeInOut(duration: 0.6), value: sheetOffset)
                .animation(.easeInOut(duration: 0.6), value: showSheet)
            }
            .navigationTitle("Watchlist")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading: NavigationLink(destination: TipsView()) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
            }, trailing: Button(action: {
                data.getStocksData()
            }) {
                Image(systemName: "gobackward")
            })
            .onReceive(timer, perform: { _ in
                if data.getMarketStatus() {
                    data.getStocksData()
                }
            })
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        data.userStocksOrder.remove(atOffsets: offsets)
        data.saveData()
    }
    
    
    func d2(symbol: String) {
        if let index = data.userStocksOrder.firstIndex(where: { loopingSymbol -> Bool in
            return symbol == loopingSymbol
        }) {
            data.userStocksOrder.remove(at: index)
        }
    }
}




struct WatchlistTileView: View {
    
    var stockQuote: StockQuote
    
    var body: some View {
        ZStack {
            Color("White Black")
            HStack {
                Text(stockQuote.symbol)
                    .foregroundColor(Color("Black White"))
                    .padding(.leading, 10)
                    .padding(.vertical, 12)
                    .font(.system(size: 19))
                VStack {
                    HStack {
                        Spacer()
                        Text(stockQuote.lastPrice.withCommas(withRupeeSymbol: false))
                            .font(.system(size: 17))
                    }
                    HStack {
                        Spacer()
                        Text("\(stockQuote.pChange.withCommas(withRupeeSymbol: false))%")
                            .font(.system(size: 14))
                    }
                }
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
