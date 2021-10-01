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
    @State var showSheet = false
    @State var selectedStock = StockQuote()
    @State var sheetOffset = CGSize(width: 0, height: 750)
    @State var isAdding = false
    @State var searchText = ""
    let timer = Timer.publish(every: 30, tolerance: 5, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    SearchBar(placeholderText: "Add stocks...", searchText: $searchText, isEditing: $isAdding)
                    
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
                                Text("Welcome to Demo Trading! To begin, add a stock to your watchlist using the search bar above 👆. Tap on it and select buy to buy that stock. You have been given ₹ 1,00,000 in fantasy money to buy stocks of your choosing! \nBest of luck and happy trading!")
//                                to begin on your journey of ups (hopefully more) and downs (hopefully less) in the stock market!
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                Spacer()
                            }
                            }
                        } else if data.stockQuotes.count == 0 {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    ZStack {
                                        Text("Loading...")
                                            .font(.title)
                                        iActivityIndicator(style: .arcs(count: 5, width: 5, spacing: 3))
                                            .padding(50)
                                            .foregroundColor(Color("Blue"))
                                    }
                                    Spacer()
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
                                // todo - improve efficiency by not looping over everything, instead find more efficient way
                                ForEach(data.userStocksOrder, id: \.self) { stock in
                                    ForEach(data.stockQuotes) { stockQuote in
                                        if stockQuote.symbol == stock {
                                            Button(action: {
                                                sheetOffset = CGSize.zero
                                                showSheet = true
                                                selectedStock = stockQuote
                                            }) {
                                                WatchlistTileView(stockQuote: stockQuote)
                                            }
                                        }
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
                        List(data.stockQuotes.filter { searchText.isEmpty ? true : $0.symbol.contains(searchText) }) { stock in
                            HStack {
                                Text(stock.symbol)
                                Spacer()
                                Button(action: {
                                    if data.userStocksOrder.contains(stock.symbol) {
                                        d2(symbol: stock.symbol)
                                    } else {
                                        if data.userStocksOrder.count < 25 {
                                    data.userStocksOrder.append(stock.symbol)
                                        }
                                    }
                                    
                                    data.saveData()
                                }) {
                                    if data.userStocksOrder.contains(stock.symbol) {
                                        Image(systemName: "hand.thumbsup.fill")
                                    } else {
                                    Image(systemName: "plus.square")
                                    }
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color("Light Gray"))
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
                                    if self.sheetOffset.height > -1.0 {
                                        self.sheetOffset = gesture.translation
                                    }
                                }
                                .onEnded { _ in
                                    if sheetOffset.height > 20 {
                                        sheetOffset.height = 750
                                        showSheet = false
                                        dismissKeyboard()
                                    } else {
                                        sheetOffset.height = 0
                                    }
                                }
                        )
                        NavigationView {
                            StockDetailView(stockQuote: selectedStock, showTitle: false)
                        }
                    }
                    .frame(height: 325)
                }
                .opacity(showSheet ? 1 : 0)
                .offset(y: sheetOffset.height)
                .animation(.easeInOut(duration: 0.6))
            }
            .navigationTitle("Watchlist")
            .navigationBarItems(leading: NavigationLink(destination: TipsView()) {
                Image(systemName: "eyeglasses")
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
        for x in offsets {
            let stockToBeDeleted = data.stockQuotes[x]
            if let index = data.userStocksOrder.firstIndex(where: { loopingStock -> Bool in
                return stockToBeDeleted.symbol == loopingStock
            }) {
                data.userStocksOrder.remove(at: index)
            }
        }
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
                    .padding(.vertical, 10)
                    .font(.system(size: 20))
                VStack {
                    HStack {
                        Spacer()
                        Text(String(format: "%.2f", stockQuote.lastPrice))
                            .font(.system(size: 18))
                    }
                    HStack {
                        Spacer()
                        Text("\(String(format: "%.2f", stockQuote.pChange))%")
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
