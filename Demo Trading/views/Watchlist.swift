//
//  WatchlistView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI
import iActivityIndicator
import SwiftDate

enum Tabs {
    case FirstTab
    case SecondTab
    case ThirdTab
}


struct WatchlistView: View {
    
    @State var selectedTab = Tabs.FirstTab
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        NavigationView {
            VStack {
                if data.tabsShowing {
                    ZStack {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("First")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedTab == .FirstTab ? Color.blue : Color("Black White"))
                                
                            }
                            .onTapGesture {
                                self.selectedTab = .FirstTab
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Second")
                                    .foregroundColor(selectedTab == .SecondTab ? Color.blue : Color("Black White"))
                            }
                            .onTapGesture {
                                self.selectedTab = .SecondTab
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Third")
                                    .foregroundColor(selectedTab == .ThirdTab ? Color.blue : Color("Black White"))
                            }
                            .onTapGesture {
                                self.selectedTab = .ThirdTab
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 3)
                            .offset(x: getXOffset(), y: 15)
                            .animation(.easeInOut(duration: 0.2), value: getXOffset())
                    }
                    
                    Spacer()
                }
                
                if selectedTab == .FirstTab {
                    WatchlistChildView(watchlistIndex: 0)
                } else if selectedTab == .SecondTab {
                    WatchlistChildView(watchlistIndex: 1)
                } else {
                    WatchlistChildView(watchlistIndex: 2)
                }
            }
            .navigationTitle("Watchlist")
            .navigationBarTitleDisplayMode(.automatic)
            
        }
    }
    func getXOffset() -> CGFloat {
        let width = UIScreen.main.bounds.width
        switch selectedTab {
        case .FirstTab:
            return -width/3.5
        case .SecondTab:
            return 0
        case .ThirdTab:
            return width/3.5
        }
    }
}


struct WatchlistChildView: View {
    
    var watchlistIndex: Int
    @ObservedObject var data = DataController.shared
    @State private var showSheet = false
    @State private var selectedStock = StockQuote()
    @State private var sheetOffset: CGFloat = 750
    @State private var isAdding = false
    @State private var searchText = ""
    @State private var editMode: EditMode = .inactive
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                SearchBar(placeholderText: "Add stocks...", searchText: $searchText, isEditing: $isAdding, showSheet: $showSheet, sheetOffset: $sheetOffset)
                    .padding(.top, isAdding && !UIDevice.current.hasNotch ? 25 : 0)
                
                if !isAdding {
                    if data.watchlist[watchlistIndex].count == 0 {
                        ZStack {
                            Image("watchlist")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color.blue)
                                .opacity(colorScheme == ColorScheme.light ? 0.15 : 0.25)
                                .padding(50)
                            VStack {
                                Spacer()
                                Text("Howdy!")
                                    .font(.title3)
                                Text("Welcome to Demo Trading! To get started, tap on the light bulb in the top left corner. ↖")
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
                                .foregroundColor(Color.blue)
                        }
                        Spacer()
                        
                    } else {
                        ZStack {
                            if data.watchlist[watchlistIndex].count < 3 {
                                VStack {
                                    Image("watchlist")
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(Color.blue)
                                        .opacity(0.9)
                                        .padding(40)
                                }
                            }
                            List {
                                ForEach(data.watchlist[watchlistIndex], id: \.self) { stock in
                                    let stockQuote = data.getStockQuote(stockSymbol: stock)
                                    WatchlistTileView(stockQuote: stockQuote)
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                            data.tabsShowing = false
                                            }
                                            sheetOffset = 0
                                            showSheet = true
                                            selectedStock = stockQuote
                                        }
                                        .onLongPressGesture {
                                            editMode = .active
                                        }
                                }
                                .onMove(perform: { indexSet, index in
                                    data.watchlist[watchlistIndex].move(fromOffsets: indexSet, toOffset: index)
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
                    List(data.stockQuotes.filter { searchText.isEmpty ? true : $0.symbol.contains(searchText) }) { stock in // if searchText is empty, then return true. otherwise, return true if loopingStockQuote symbol contains the searchText (excluding whitespaces i.e spaces)
                        HStack {
                            Text(stock.symbol)
                            Spacer()
                            Button(action: {
                                if data.watchlist[watchlistIndex].contains(stock.symbol) {
                                    d2(symbol: stock.symbol)
                                } else {
                                    if data.watchlist[watchlistIndex].count < 50 {
                                        data.watchlist[watchlistIndex].append(stock.symbol)
                                    } else {
                                        data.showMessage(message: "Can't add more than 50 stocks to watchlist.")
                                    }
                                }
                                data.saveData()
                            }) {
                                Image(systemName: data.watchlist[watchlistIndex].contains(stock.symbol) ? "hand.thumbsup.fill" : "plus.square")
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
                                .font(.custom("Poppins-Light", size: 25))
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
                                    withAnimation(.spring()) {
                                    data.tabsShowing = true
                                    }
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
        
        .navigationBarItems(trailing: Button(action: {
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
    }
    
    
    func delete(at offsets: IndexSet) {
        data.watchlist[watchlistIndex].remove(atOffsets: offsets)
        data.saveData()
    }
    
    
    func d2(symbol: String) {
        if let index = data.watchlist[watchlistIndex].firstIndex(where: { loopingSymbol -> Bool in
            return symbol == loopingSymbol
        }) {
            data.watchlist[watchlistIndex].remove(at: index)
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
                    .font(.custom("Poppins-Light", size: 19))
                VStack {
                    HStack {
                        Spacer()
                        Text(stockQuote.lastPrice.withCommas())
                            .font(.custom("Poppins-Light", size: 17))
                    }
                    HStack {
                        Spacer()
                        Text("\(stockQuote.change < 0 ? "" : "+")\(stockQuote.pChange.withCommas())%")
                            .font(.custom("Poppins-Light", size: 14))
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
