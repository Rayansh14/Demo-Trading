//
//  Transact.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 29/09/21.
//

import SwiftUI


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
                    if intNumberOfShares > 0 {
                    order.numberOfShares = intNumberOfShares
                    data.processOrder(order: order)
                    presentationMode.wrappedValue.dismiss()
                    } else {
                        data.showMessage(message: "LOL")
                    }
                } else {
                    data.showMessage(message: "Please enter a valid number of shares.")
                }
            }) {
                Text("Execute")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color("Blue"))
                    .cornerRadius(10)
            }
            .disabled(numberOfShares == "" ? true : false)
            .disabled(stockQuote.lastPrice == 0 ? true : false)
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
