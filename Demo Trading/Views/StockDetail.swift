//
//  StockDetailView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct StockDetailView: View {
    
    var stockSymbol = ""
    var isFullScreen = false
    var stockQuote = StockQuote()
    
    init(stockSymbol: String, isFullScreen: Bool) {
        self.stockSymbol = stockSymbol
        self.isFullScreen = isFullScreen
        self.stockQuote = data.getStockQuote(stockSymbol: stockSymbol)
    }
    
    @ObservedObject var data = DataController.shared
    @State private var stockOwned = StockOwned()
    @Environment(\.presentationMode) var presentationMode
    
    
//    let stockQuote = StockQuote()
    
    var body: some View {
        ZStack {
            
            VStack {
                if !isFullScreen {
                    Spacer()
                }
                HStack {
                    VStack {
                        Text("NSE: \(stockQuote.lastPrice.withCommas(withRupeeSymbol: true))")
                        Text("\(String(format: "%.2f", stockQuote.pChange))%")
                            .foregroundColor(stockQuote.pChange >= 0.0 ? .green : .red)
                            .font(.title3)
                    }
                    Spacer()
                    if data.checkIfOwned(stockSymbol: stockQuote.symbol) {
                        Text("\(Image(systemName: "briefcase.fill")) \(data.getStockOwned(stockSymbol: stockQuote.symbol).numberOfShares)")
                    }
                }
                .padding(.horizontal, 35)
                .padding(.top, 15)
                .font(.title2)
                
                // todo: make seperate view for this info (open, low, high, previous close)
                
                HStack {
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Open")
                                .font(.system(size: 15))
                                .foregroundColor(Color("Gray"))
                                .offset(x: 0, y: -3)
                            Text(stockQuote.open.withCommas(withRupeeSymbol: false))
                                .offset(x: 0, y: 3)
                                .font(.system(size: 15.5))
                        }
                        Spacer()
                        
                        Rectangle()
                            .frame(width: 1, height: 70)
                            .foregroundColor(Color("Divider Gray"))
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Low")
                                .font(.system(size: 15))
                                .foregroundColor(Color("Gray"))
                                .offset(x: 0, y: -3)
                            Text(stockQuote.dayLow.withCommas(withRupeeSymbol: false))
                                .offset(x: 0, y: 3)
                                .font(.system(size: 15.5))
                        }
                        Spacer()
                        
                        Rectangle()
                            .frame(width: 1, height: 70)
                            .foregroundColor(Color("Divider Gray"))
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("High")
                                .font(.system(size: 15))
                                .foregroundColor(Color("Gray"))
                                .offset(x: 0, y: -3)
                            Text(stockQuote.dayHigh.withCommas(withRupeeSymbol: false))
                                .offset(x: 0, y: 3)
                                .font(.system(size: 15.5))
                        }
                        Spacer()
                        
                        Rectangle()
                            .frame(width: 1, height: 70)
                            .foregroundColor(Color("Divider Gray"))
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Prev. Close")
                                .font(.system(size: 15))
                                .foregroundColor(Color("Gray"))
                                .offset(x: 0, y: -3)
                            Text(stockQuote.previousClose.withCommas(withRupeeSymbol: false))
                                .offset(x: 0, y: 3)
                                .font(.system(size: 15.5))
                        }
                        Spacer()
                    }
                }
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                
                if !isFullScreen {
                    Spacer()
                }
                
                
                if !(stockQuote.symbol.contains("NIFTY")) {
                        
                        HStack {
                            NavigationLink(destination: TransactStockView(orderType: .buy, stockSymbol: stockSymbol, isFullScreen: isFullScreen)) {
                                Text("Buy")
                                    .frame(width: 150)
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                                    .padding(.vertical, 12)
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 1)
                            }
                            NavigationLink(destination: TransactStockView(orderType: .sell, stockSymbol: stockSymbol, isFullScreen: isFullScreen)) {
                                Text("Sell")
                                    .frame(width: 150)
                                    .foregroundColor(.white)
                                    .font(.system(size: 24))
                                    .padding(.vertical, 12)
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 1)
                            }
                        }
                        .animation(.none)
                        .padding(.vertical, 10)
                    
                    if isFullScreen {
                        
                        VStack {
                            CustomInfoView(label: "Buy Value:", info: ((stockOwned.avgPriceBought * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true)))
                                .padding(.top)
                            
                            CustomInfoView(label: "Current Value:", info: ((stockOwned.lastPrice * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true)))
                                .padding(.top, 1)
                            
                            CustomInfoView(label: "Profit/Loss:", info: ((stockOwned.lastPrice - stockOwned.avgPriceBought) * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true))
                            .padding(.top, 1)
                            
                            CustomInfoView(label: "Weightage in Portfolio:", info: "\((stockOwned.lastPrice * 100 * Double(stockOwned.numberOfShares) / data.getPorfolioInfo(portfolio: data.portfolio)["currentValue"]!).withCommas(withRupeeSymbol: false))%")
                                .padding(.top, 1)
                        }
                    }
                        
                    
                    Spacer()
                }
                
                Spacer()
            }
            .animation(.none)
            
        }
        .onDisappear(perform: {
            self.presentationMode.wrappedValue.dismiss()
        })
        .onAppear(perform: {
            stockOwned = data.getStockOwned(stockSymbol: stockSymbol)
        })
        .if({
            isFullScreen
        }()) { view in
            view.navigationTitle(stockSymbol)
        }
        .if({
            !isFullScreen
        }()) { view in
            view.navigationBarHidden(true)
        }
    }
}


struct CustomInfoView: View {
    var label: String
    var info: String
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(info)
        }
        .font(.system(size: 16))
        .padding(.horizontal)
    }
}



struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stockSymbol: "RELIANCE", isFullScreen: true)
//                .preferredColorScheme(.dark)
        }
    }
}
