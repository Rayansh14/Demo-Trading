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
            if !(stockQuote.symbol.contains("NIFTY")) {
                
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
                    
                    if !showTitle {
                        Spacer()
                    }
                    
                    
                    
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
                            HStack {
                                Text("Buy Value:")
                                Spacer()
                                Text((stockOwned.avgPriceBought * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true))
                            }
                            .padding(.horizontal)
                            .padding(.top)
                                
                            HStack {
                                Text("Current Value:")
                                Spacer()
                                Text((stockOwned.lastPrice * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true))
                            }
                            .padding(.horizontal)
                            .padding(.top, 1)
                            
                            HStack {
                                Text("Profit/Loss: ")
                                Spacer()
                                Text(((stockOwned.lastPrice - stockOwned.avgPriceBought) * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true))
                            }
                            .padding(.horizontal)
                            .padding(.top, 1)
                        }
                    }
                    
                    Spacer()
                }
                
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




struct TransactStockView: View {
    
    var orderType: OrderType
    var stockQuote: StockQuote
    var showTitle: Bool
    @ObservedObject var data = DataController.shared
    @StateObject var order = Order()
    @State var numberOfShares = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
            Text(orderType.rawValue.capitalized)
                Spacer()
                Button(action: {self.numberOfShares = buyMaxShares(sharePrice: stockQuote.lastPrice)}) {
                    Text("Max")
                }
            }
            Text(String(stockQuote.lastPrice))
            TextField("Number of shares", text: $numberOfShares)
                .padding(5)
                .border(Color("Black White"), width: 1)
                .padding()
                .keyboardType(.numberPad)
            Button(action: {
                order.type = orderType
                order.sharePrice = stockQuote.lastPrice
                order.stockSymbol = stockQuote.symbol
                order.time = Date()
                if let intNumberOfShares = Int(numberOfShares) {
                    order.numberOfShares = intNumberOfShares
                    data.processOrder(order: order)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    data.showErrorMessage(message: "Please enter a valid number of shares.")
                }
            }) {
                Text("Execute")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(numberOfShares == "" ? true : false)
        }
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
    
    func buyMaxShares(sharePrice: Double) -> String {
        return String(Int(data.funds/sharePrice))
    }
}


struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stockQuote: testStockQuote, showTitle: true)
        }
    }
}
