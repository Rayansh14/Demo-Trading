//
//  Transact.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 29/09/21.
//

import SwiftUI
import SwiftDate


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
                    HStack {
                    Text(stockSymbol)
                        .font(.system(size: 28, weight: .regular, design: .serif))
                        if let stockOwned = data.getStockOwned(stockSymbol: stockSymbol) {
                            Spacer()
                            Text("\(Image(systemName: "briefcase.fill")) \(stockOwned.numberOfShares)")
                        }
                    }
                }
                
                Text("NSE: \(stockQuote.lastPrice.withCommas(withRupeeSymbol: true))")
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .if(isFullScreen, transform: { view in
                        view.padding(.bottom, 10)
                    })
                        
                        HStack {
                        Text(orderType.rawValue.capitalized)
                            .font(.system(size: 25, weight: .regular, design: .serif))
                        
                        Spacer()
                        
//                        Button(action: {
//                            if orderType == .buy {
//                                numberOfShares = buyMaxShares(sharePrice: stockQuote.lastPrice)
//                            } else {
//                                numberOfShares = String(data.getStockOwned(stockSymbol: stockQuote.symbol).numberOfShares)
//                            }}) {
//                                Text("\(orderType.rawValue.capitalized) Max Shares")
//                                    .font(.system(size: 20, weight: .regular, design: .serif))
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal)
//                                    .padding(.vertical, 10)
//                                    .background(orderType == .buy ? Color("Blue") : Color.red)
//                                    .cornerRadius(100)
//                            }
                    }
                HStack {
                    Button(action: {
                        numberOfShares = percentShares(percent: 0.25)
                    }) {
                        PercentageText(text: "25%")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        numberOfShares = percentShares(percent: 0.50)
                    }) {
                        PercentageText(text: "50%")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        numberOfShares = percentShares(percent: 0.75)
                    }) {
                        PercentageText(text: "75%")
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        numberOfShares = percentShares(percent: 1)
                    }) {
                        PercentageText(text: "100%")
                    }
                }
            }
            .padding(.horizontal, 20)
            
            
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
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(orderType == .buy ? Color("Blue") : Color.red, lineWidth: 1)
                        .offset(x: -5)
                )
                .padding()
            
            HStack {
                Spacer()
                
                Button(action: {
                    if let intNumberOfShares = Int(numberOfShares) {
                        if intNumberOfShares > 0 {
                            if (stockQuote.updateTime + 2.minutes) > Date.now {
                                order.type = orderType
                                order.sharePrice = stockQuote.lastPrice
                                order.stockSymbol = stockQuote.symbol
                                order.time = Date()
                                order.numberOfShares = intNumberOfShares
                                data.processOrder(order: order)
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                data.showMessage(message: "The stock price hasn't been refreshed in a while. Try manually refreshing it from your watchlist tab")
                            }
                        } else {
                            data.showMessage(message: "LOL")
                        }
                    } else {
                        data.showMessage(message: "Please enter a valid number of shares.")
                    }
                }) {
                    Text("Execute")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium, design: .serif))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(orderType == .buy ? Color("Blue") : Color.red)
                        .cornerRadius(100)
                }
                .padding(.bottom)
                .disabled(numberOfShares == "" ? true : false)
                .disabled(stockQuote.lastPrice == 0 ? true : false)
                Spacer()
            }
        }
        .onDisappear(perform: {
            textFieldFocused = false
            presentationMode.wrappedValue.dismiss()
        })
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
    
    func percentShares(percent: Double) -> String {
        if orderType == .buy {
            return String(Int(data.funds/stockQuote.lastPrice*percent))
        } else {
            if let stockOwned = data.getStockOwned(stockSymbol: stockSymbol) {
                return String(Int(Double(stockOwned.numberOfShares)*percent))
            }
            return "0"
        }
        
    }
}

struct PercentageText: View {
    var text: String
    var body: some View {
        Text(text)
            .foregroundColor(Color("Gray"))
            .font(.system(size: 20, weight: .regular, design: .serif))
    }
}


struct TransactView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                TransactStockView(orderType: .buy, stockSymbol: "RELIANCE", isFullScreen: true)
                //                    .preferredColorScheme(.dark)
            }
        }
    }
}
