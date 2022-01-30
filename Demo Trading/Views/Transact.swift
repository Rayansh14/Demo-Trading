//
//  Transact.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 29/09/21.
//

import SwiftUI
import SwiftDate


struct TransactStockView: View {
    
    var transactionType: TransactionType = .buy
    var stockSymbol: String = ""
    var isFullScreen: Bool = true
    var stockQuote = StockQuote()
    
    init(transactionType: TransactionType, stockSymbol: String, isFullScreen: Bool) {
        self.transactionType = transactionType
        self.stockSymbol = stockSymbol
        self.isFullScreen = isFullScreen
        self.stockQuote = data.getStockQuote(stockSymbol: stockSymbol)
    }
    
    @State private var isMarket = true
    @ObservedObject var data = DataController.shared
    @StateObject var order = Order()
    @State private var numberOfShares = ""
    @State private var sharePrice = ""
    @FocusState var textFieldFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView {
                
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
                        .padding(.bottom, isFullScreen ? 10 : 0)
                    
                    HStack {
                        Text(transactionType.rawValue.capitalized)
                            .font(.system(size: 25, weight: .regular, design: .serif))
                        Spacer()
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
                
                HStack {
                    Text("Order Type")
                        .padding(.leading)
                        .padding(.bottom, 1)
                        .font(.system(size: 20, weight: .regular, design: .serif))
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        isMarket = true
                        textFieldFocused = true
                        sharePrice = ""
                    }) {
                        Text("Market")
                            .font(.system(size: 24, weight: .regular, design: .serif))
                        
                    }
                    .foregroundColor(isMarket ? .blue : .gray)
                    
                    Spacer()
                    
                    Button(action: {isMarket = false}) {
                        Text("Limit")
                            .font(.system(size: 24, weight: .regular, design: .serif))
                    }
                    .foregroundColor(isMarket ? .gray : .blue)
                    Spacer()
                }
                
                TextField("Number of shares", text: $numberOfShares)
                    .focused($textFieldFocused)
                    .font(.system(size: 20, weight: .regular, design: .serif))
                    .padding(7)
                    .keyboardType(.numberPad)
                    .font(.title)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(transactionType == .buy ? Color("Blue") : Color.red, lineWidth: 1)
                            .offset(x: -5)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                TextField("Price", text: $sharePrice)
                    .font(.system(size: 20, weight: .regular, design: .serif))
                    .padding(7)
                    .keyboardType(.decimalPad)
                    .font(.title)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(transactionType == .buy ? Color("Blue") : Color.red, lineWidth: 1)
                            .offset(x: -5)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .disabled(isMarket)
                    .opacity(isMarket ? 0.5 : 1)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if let intNumberOfShares = Int(numberOfShares) {
                            if intNumberOfShares > 0 {
                                order.transactionType = transactionType
                                order.sharePrice = stockQuote.lastPrice
                                order.stockSymbol = stockQuote.symbol
                                order.orderType = isMarket ? .market : .limit
                                if !isMarket {
                                    if let doubleSharePrice = Double(sharePrice) {
                                        if (transactionType == .buy && doubleSharePrice < stockQuote.lastPrice) || (transactionType == .sell && doubleSharePrice > stockQuote.lastPrice) {
                                            order.sharePrice = doubleSharePrice
                                        }
                                    }
                                }
                                order.numberOfShares = intNumberOfShares
                                data.processOrder(order: order, quoteUpdateTime: stockQuote.updateTime)
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
                            .font(.system(size: 25, weight: .medium, design: .serif))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(transactionType == .buy ? Color("Blue") : Color.red)
                            .cornerRadius(100)
                    }
                    .padding(.bottom)
                    .disabled(numberOfShares == "" ? true : false)
                    .disabled(stockQuote.lastPrice == 0 ? true : false)
                    Spacer()
                }
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
        .toolbar {
            ToolbarItem (placement: .navigation)  {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
                .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func percentShares(percent: Double) -> String {
        if transactionType == .buy {
            if stockQuote.lastPrice > 0 {
                return String(Int(data.funds/stockQuote.lastPrice*percent))
            }
        } else {
            if let stockOwned = data.getStockOwned(stockSymbol: stockSymbol) {
                return String(Int(Double(stockOwned.numberOfShares)*percent))
            }
        }
        return "0"
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
                TransactStockView(transactionType: .buy, stockSymbol: "RELIANCE", isFullScreen: true)
                //                    .preferredColorScheme(.dark)
            }
        }
    }
}
