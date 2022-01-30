//
//  WatchlistView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI
import iActivityIndicator
import SwiftDate

struct WatchlistView: View {
    
    @ObservedObject var data = DataController.shared
    @State private var showSheet = false
    @State private var selectedStock = StockQuote()
    @State private var sheetOffset: CGFloat = 750
    @State private var isAdding = false
    @State private var searchText = ""
    @State private var editMode: EditMode = .inactive
    private let timer = Timer.publish(every: 25, tolerance: 5, on: .main, in: .common).autoconnect()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    SearchBar(placeholderText: "Add stocks...", searchText: $searchText, isEditing: $isAdding, showSheet: $showSheet, sheetOffset: $sheetOffset)
                    
                    if !isAdding {
                        if data.userStocksOrder.count == 0 {
                            ZStack {
                                Image("watchlist")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color("Blue"))
                                    .opacity(colorScheme == ColorScheme.light ? 0.15 : 0.25)
                                    .padding(50)
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
                            Spacer()
                            ZStack(alignment: .center) {
                                Text("Loading...")
                                    .font(.title)
                                iActivityIndicator(style: .arcs(count: 5, width: 5, spacing: 3))
                                    .padding(50)
                                    .foregroundColor(Color("Blue"))
                            }
                            Spacer()
                            
                        } else {
                            ZStack {
                                if data.userStocksOrder.count < 3 {
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
                                        WatchlistTileView(stockQuote: stockQuote)
                                            .onTapGesture {
                                                sheetOffset = 0
                                                showSheet = true
                                                selectedStock = stockQuote
                                            }
                                            .onLongPressGesture {
                                                editMode = .active
                                            }
                                    }
                                    .onMove(perform: { indexSet, index in
                                        data.userStocksOrder.move(fromOffsets: indexSet, toOffset: index)
                                        data.saveData()
                                    })
                                    .onDelete { indexSet in
                                        delete(at: indexSet)
                                    }
                                }
                                .environment(\.editMode, $editMode)
                                .listStyle(PlainListStyle())
                                .animation(.default, value: editMode)
                            }
                        }
                        
                    } else {
                        List(data.stockQuotes.filter { searchText.isEmpty ? true : $0.symbol.contains(searchText.filter {!$0.isWhitespace}) }) { stock in // if searchText is empty, then return true. otherwise, return true if loopingStockQuote symbol contains the searchText (excluding whitespaces i.e spaces)
                            HStack {
                                Text(stock.symbol)
                                Spacer()
                                Button(action: {
                                    if data.userStocksOrder.contains(stock.symbol) {
                                        d2(symbol: stock.symbol)
                                    } else {
                                        if data.userStocksOrder.count < 50 {
                                            data.userStocksOrder.append(stock.symbol)
                                        } else {
                                            data.showMessage(message: "Can't add more than 50 stocks to watchlist.")
                                        }
                                    }
                                    data.saveData()
                                }) {
                                    Image(systemName: data.userStocksOrder.contains(stock.symbol) ? "hand.thumbsup.fill" : "plus.square")
                                        .imageScale(.large)
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
                                .frame(height: 50)
                                .cornerRadius(10)
                            HStack {
                                Text(selectedStock.symbol)
                                    .font(.system(size: 25))
                                    .padding(.horizontal)
                                Spacer()
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if self.sheetOffset > -1.0 {
                                        self.sheetOffset = gesture.translation.height
                                    }
                                }
                                .onEnded { _ in
                                    if sheetOffset > 20 {
                                        sheetOffset = 750
                                        showSheet = false
                                        UIApplication.shared.dismissKeyboard()
                                    } else {
                                        sheetOffset = 0
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
                .offset(y: sheetOffset)
                .animation(.easeInOut(duration: 0.6), value: sheetOffset)
                .animation(.easeInOut(duration: 0.6), value: showSheet)
            }
            .navigationTitle("Watchlist")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading: NavigationLink(destination: TipsView()) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
            }, trailing: Button(action: {
                if editMode == .active {
                    editMode = .inactive
                } else {
                    data.getStocksData()
                }
            }) {
                if editMode == .active {
                    Text("Done")
                } else {
                    Image(systemName: "gobackward")
                }
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
                    .padding(.vertical, 12)
                    .font(.system(size: 19))
                VStack {
                    HStack {
                        Spacer()
                        Text(stockQuote.lastPrice.withCommas())
                            .font(.system(size: 17))
                    }
                    HStack {
                        Spacer()
                        Text("\(stockQuote.change < 0 ? "" : "+")\(stockQuote.pChange.withCommas())%")
                            .font(.system(size: 14))
//                            .foregroundColor(Color("Black White"))
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
