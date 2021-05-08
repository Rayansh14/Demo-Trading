//
//  StockDetailView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct StockDetailView: View {
    
    var stockQuote: StockQuote
    @State var showBuyView = false
    @State var showSellView = false
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        NavigationView {
            ZStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showBuyView = true
                    }) {
                        Text("Buy")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showBuyView) {
                        BuyStockView(stockQuote: stockQuote)
                    }
                    Button(action: {
                        showSellView = true
                    }) {
                        Text("Sell")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showSellView) {
                        SellStockView(stockQuote: stockQuote)
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    ErrorTileView(error: data.errorMessage)
                        .opacity(data.showError ? 1.0 : 0.0)
                        .animation(.easeInOut)
                        .padding(.bottom)
                }
            }
            .navigationTitle(stockQuote.symbol)
        }
    }
}









struct BuyStockView: View {
    
    var stockQuote: StockQuote
    @StateObject var order = Order()
    @State var numberOfShares = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Buy")
                Text(String(stockQuote.lastPrice))
                TextField("Number of shares", text: $numberOfShares)
                    .padding(5)
                    .border(Color("Black White"), width: 1)
                    .padding()
                    .keyboardType(.numberPad)
                Button(action: {
                    order.type = .buy
                    order.sharePrice = stockQuote.lastPrice
                    order.stockSymbol = stockQuote.symbol
                    order.numberOfShares = Int(numberOfShares)!
                    order.time = Date()
                    DataController.shared.processOrder(order: order)
                    presentationMode.wrappedValue.dismiss()
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
            .navigationTitle(stockQuote.symbol)
        }
        
    }
}








struct SellStockView: View {
    
    @State var stockQuote: StockQuote
    @StateObject var order = Order()
    @State var numberOfShares = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Sell")
                Text(String(stockQuote.lastPrice))
                TextField("Number of shares", text: $numberOfShares)
                    .padding(5)
                    .border(Color("Black White"), width: 1)
                    .padding()
                    .keyboardType(.numberPad)
                Button(action: {
                    order.type = .sell
                    order.sharePrice = stockQuote.lastPrice
                    order.stockSymbol = stockQuote.symbol
                    order.numberOfShares = Int(numberOfShares)!
                    order.time = Date()
                    DataController.shared.processOrder(order: order)
                    presentationMode.wrappedValue.dismiss()
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
            .navigationTitle(stockQuote.symbol)
        }
        
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stockQuote: testStockQuote)
        }
    }
}
