//
//  Transact.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 29/09/21.
//

import SwiftUI


struct TransactStockView: View {
    
    var orderType: OrderType = .buy
    var stockSymbol: String = ""
    var isFullScreen: Bool = true
    var stockQuote = StockQuote()
    
    init(orderType: OrderType, stockSymbol: String, isFullScreen: Bool) {
        self.orderType = orderType
        self.stockSymbol = stockSymbol
        self.isFullScreen = isFullScreen
        self.stockQuote = data.getStockQuote(stockSymbol: stockSymbol)
    }
    
    @ObservedObject var data = DataController.shared
    @StateObject var order = Order()
    @State private var numberOfShares = ""
    @FocusState var textFieldFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 5) {
                if isFullScreen {
                    Text(stockSymbol)
                        .font(.system(size: 28, weight: .regular, design: .serif))
                }
                
                Text("NSE: \(stockQuote.lastPrice.withCommas(withRupeeSymbol: true))")
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .if(isFullScreen, transform: { view in
                        view.padding(.bottom, 10)
                    })
                        Text(orderType.rawValue.capitalized)
                        .font(.system(size: 25, weight: .regular, design: .serif))
                        
                        Button(action: {
                            if orderType == .buy {
                                numberOfShares = buyMaxShares(sharePrice: stockQuote.lastPrice)
                            } else {
                                numberOfShares = String(data.getStockOwned(stockSymbol: stockQuote.symbol).numberOfShares)
                            }}) {
                        Text("\(orderType.rawValue.capitalized) Max Shares")
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .foregroundColor(orderType == .buy ? Color("Blue") : .red)
                    }
            }
            .padding(.leading, 20)
            
            
            Spacer()
            
            
            if isFullScreen {
                // hstack is there so that when image shrinks, it still stays in the middle of the screen.
                HStack {
                    Spacer()
                    Image("handshake")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, -30)
                    Spacer()
                }
            }
            
            
            TextField("Number of shares", text: $numberOfShares)
                .focused($textFieldFocused)
                .font(.system(size: 20, weight: .regular, design: .serif))
                .padding(7)
                .keyboardType(.numberPad)
                .font(.title)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(orderType == .buy ? Color("Blue") : Color.red, lineWidth: 1))
                .padding()
            
            HStack {
                Spacer()
                
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
                        .font(.system(size: 26, weight: .medium, design: .serif))
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                        .background(orderType == .buy ? Color("Blue") : Color.red)
                        .cornerRadius(10)
                }
                .padding(.bottom)
                .disabled(numberOfShares == "" ? true : false)
                .disabled(stockQuote.lastPrice == 0 ? true : false)
                Spacer()
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                textFieldFocused = true
            }
        })
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem (placement: .navigation)  {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
                .onTapGesture {
                    // code to dismiss the view
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func buyMaxShares(sharePrice: Double) -> String {
        return String(Int(data.funds/sharePrice))
    }
}


struct TransactView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                TransactStockView(orderType: .buy, stockSymbol: "RELIANCE", isFullScreen: true)
            }
        }
    }
}