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
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: TransactStockView(orderType: .buy, stockQuote: stockQuote)) {
                        Text("Buy")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: TransactStockView(orderType: .sell, stockQuote: stockQuote)) {
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
    @StateObject var order = Order()
    @State var numberOfShares = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text(orderType.rawValue.capitalized)
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
                    DataController.shared.processOrder(order: order)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    DataController.shared.showErrorMessage(message: "Pls enter a valid number of shares.")
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
        .navigationTitle(stockQuote.symbol)
    }
}


struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stockQuote: testStockQuote, showTitle: true)
        }
    }
}
