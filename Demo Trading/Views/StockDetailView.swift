//
//  StockDetailView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct StockDetailView: View {
    
    @State var stockQuote: StockQuote
    @State var showTransactView = false
    @State var orderType = OrderType.buy
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                showTransactView = true
                orderType = .buy
            }) {
                Text("Buy")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            Button(action: {
                showTransactView = true
                orderType = .sell
            }) {
                Text("Sell")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .sheet(isPresented: $showTransactView) {
            TransactStockView(stockQuote: stockQuote, orderType: orderType)
        }
        .navigationTitle(stockQuote.symbol)
    }
}


struct TransactStockView: View {
    
    @State var stockQuote: StockQuote
    @StateObject var order = Order()
    @State var numberOfShares = ""
    @Environment(\.presentationMode) var presentationMode
    @State var orderType: OrderType
    
    var body: some View {
        NavigationView {
            VStack {
                Text(orderType == .buy ? "Buy" : "Sell")
                Text(String(stockQuote.lastPrice))
                TextField("Number of shares", text: $numberOfShares)
                    .padding(5)
                    .border(Color.black, width: 1)
                    .padding()
                    .keyboardType(.numberPad)
                Button(action: {
                    order.type = orderType
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
            }
            .navigationTitle(stockQuote.symbol)
        }
        
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView(stockQuote: testStockQuote)
    }
}
