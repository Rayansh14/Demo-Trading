//
//  StockDetailView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct StockDetailView: View {
    
    var stockQuote: StockQuote
    var showTitle: Bool
    @ObservedObject var data = DataController.shared
    @State var stockOwned = StockOwned()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
                
                VStack {
                    
                    HStack {
                        VStack {
                            Text("NSE: \(stockQuote.lastPrice.withCommas(withRupeeSymbol: true))")
                            Text("\(String(format: "%.2f", stockQuote.pChange))%")
                                .foregroundColor(stockQuote.pChange >= 0.0 ? .green : .red)
                        }
                        Spacer()
                        if data.checkIfOwned(stockSymbol: stockQuote.symbol) {
                            Text("\(Image(systemName: "briefcase.fill")) \(data.getStockOwned(stockSymbol: stockQuote.symbol).numberOfShares)")
                        }
                    }
                    .padding(.horizontal, 35)
                    .padding(.top, 15)
                    .font(.title2)
                    
                    
                    
                    HStack {
                        
                        Group {
                            Spacer()
                            VStack {
                                Text("Open")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("Gray"))
                                    .offset(x: 0, y: -3)
                                Text(stockQuote.open.withCommas(withRupeeSymbol: true))
                                    .offset(x: 0, y: 3)
                                    .font(.system(size: 15.5))
                            }
                            Spacer()
                            
                            Divider()
                                .frame(maxHeight: 70)
                        }
                        
                        Group {
                            Spacer()
                            VStack {
                                Text("Low")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("Gray"))
                                    .offset(x: 0, y: -3)
                                Text(stockQuote.dayLow.withCommas(withRupeeSymbol: true))
                                    .offset(x: 0, y: 3)
                                    .font(.system(size: 15.5))
                            }
                            Spacer()
                            
                            Divider()
                                .frame(maxHeight: 70)
                        }
                        
                        Group {
                            Spacer()
                            VStack {
                                Text("High")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("Gray"))
                                    .offset(x: 0, y: -3)
                                Text(stockQuote.dayHigh.withCommas(withRupeeSymbol: true))
                                        .offset(x: 0, y: 3)
                                    .font(.system(size: 15.5))
                            }
                            Spacer()
                            
                            Divider()
                                .frame(maxHeight: 70)
                        }
                        
                        Group {
                            Spacer()
                            VStack {
                                Text("Prev. Close")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color("Gray"))
                                    .offset(x: 0, y: -3)
                                Text(stockQuote.previousClose.withCommas(withRupeeSymbol: true))
                                    .offset(x: 0, y: 3)
                                    .font(.system(size: 15.5))
                            }
                            Spacer()
                        }
                    }
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .animation(.none)
                    
                    if !showTitle {
                        Spacer()
                    }
                    
                    
                        if !(stockQuote.symbol.contains("NIFTY")) {
                    
                    if !showTitle {
                        
                        HStack {
                            NavigationLink(destination: TransactStockView(orderType: .buy, stockQuote: stockQuote, showTitle: showTitle)) {
                                Text("Buy")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            NavigationLink(destination: TransactStockView(orderType: .sell, stockQuote: stockQuote, showTitle: showTitle)) {
                                Text("Sell")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                        }
                        .animation(.none)
                        
                    } else {
                        
                        HStack {
                            NavigationLink(destination: TransactStockView(orderType: .buy, stockQuote: stockQuote, showTitle: showTitle)) {
                                Text("Buy")
                                    .frame(width: 150)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .padding(.vertical, 10)
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 1)
                            }
                            NavigationLink(destination: TransactStockView(orderType: .sell, stockQuote: stockQuote, showTitle: showTitle)) {
                                Text("Sell")
                                    .frame(width: 150)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .padding(.vertical, 10)
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 1)
                            }
                        }
                        .padding(.vertical, 10)
                        
                        VStack {
                            CustomInfoView(label: "Buy Value:", info: ((stockOwned.avgPriceBought * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true)))
                                .padding(.top)
                            
                            CustomInfoView(label: "Current Value:", info: ((stockOwned.lastPrice * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true)))
                                .padding(.top, 1)
                            
                            CustomInfoView(label: "Profit/Loss:", info: ((stockOwned.lastPrice - stockOwned.avgPriceBought) * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true))
                            .padding(.top, 1)
                            
                            CustomInfoView(label: "Weightage in Portfolio:", info: "\((stockOwned.lastPrice * 100 * Double(stockOwned.numberOfShares) / data.getPorfolioInfo(portfolio: data.holdings)["currentValue"]!).withCommas(withRupeeSymbol: false))%")
                                .padding(.top, 1)
                        }
                    }
                        }
                    
                    Spacer()
                }
                
        }
        .onDisappear(perform: {
            self.presentationMode.wrappedValue.dismiss()
        })
        .onAppear(perform: {
            stockOwned = data.getStockOwned(stockSymbol: stockQuote.symbol)
        })
        .if({
            showTitle
        }()) { view in
            view.navigationTitle(stockQuote.symbol)
        }
        .if({
            !showTitle
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
        .padding(.horizontal)
    }
}



struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stockQuote: testStockQuote, showTitle: true)
        }
    }
}
