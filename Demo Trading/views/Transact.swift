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
    @State private var sharePrice = ""
    
    init(transactionType: TransactionType, stockSymbol: String, isFullScreen: Bool) {
        self.transactionType = transactionType
        self.stockSymbol = stockSymbol
        self.isFullScreen = isFullScreen
        self.stockQuote = data.getStockQuote(stockSymbol: stockSymbol)
    }
    
    @State private var isMarket = true
    @State private var scaleValue: CGFloat = 1
    @ObservedObject var data = DataController.shared
    @StateObject var order = Order()
    @State private var numberOfShares = ""
    @FocusState var numberTextFieldFocused: Bool
    @FocusState var priceTextFieldFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    if isFullScreen {
                        HStack {
                            Text(stockSymbol)
                                .font(.system(size: 28, weight: .regular, design: .serif))
                            if data.getTotalSharesOwned(stockSymbol: stockSymbol) > 0 {
                                Spacer()
                                Text("\(Image(systemName: "briefcase.fill")) \(data.getTotalSharesOwned(stockSymbol: stockSymbol))")
                            }
                        }
                    }
                    
                    Text("NSE: \(stockQuote.displayPrice.withCommas(withRupeeSymbol: true))")
                        .font(.system(size: 18, weight: .regular, design: .serif))
                        .padding(.bottom, isFullScreen ? 10 : 0)
                    
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
                    
                    //                    HStack {
                    //                        Text(transactionType.rawValue.capitalized)
                    //                            .font(.system(size: 25, weight: .regular, design: .serif))
                    //                        Spacer()
                    //                    }
                    
                    
                    
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                
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
                        numberTextFieldFocused = true
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
                    .onChange(of: numberOfShares, perform: { _ in
                        sharePrice = String(data.getStockQuote(stockSymbol: stockSymbol).displayPrice)
                    })
                    .focused($numberTextFieldFocused)
                    .font(.system(size: 20, weight: .regular, design: .serif))
                    .padding(7)
                    .keyboardType(.numberPad)
                    .font(.title)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(transactionType == .buy ? Color.blue : Color.red, lineWidth: 1)
                            .offset(x: -5)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                HStack {
                    ForEach(1..<5) { num in
                        Button(action: {
                            numberOfShares = percentShares(percent: (Double(num)*0.25))
                        }) {
                            Spacer()
                            Text("\(num*25)%")
                                .foregroundColor(Color("Gray"))
                                .font(.system(size: 18, weight: .regular, design: .serif))
                            Spacer()
                        }
                    }
                }
                .padding(.top, -10)
                
                TextField("Price", text: $sharePrice)
                    .focused($priceTextFieldFocused)
                    .font(.system(size: 20, weight: .regular, design: .serif))
                    .padding(7)
                    .keyboardType(.decimalPad)
                    .font(.title)
                    .overlay(
                        RoundedRectangle(cornerRadius: 100)
                            .stroke(transactionType == .buy ? Color.blue : Color.red, lineWidth: 1)
                            .offset(x: -5)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .disabled(isMarket)
                    .opacity(isMarket ? 0.5 : 1)
                    .onTapGesture {
                        isMarket = false
                    }
                
                HStack {
                    Spacer()
                    
                    Text("Execute")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium, design: .serif))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(transactionType == .buy ? Color.blue : Color.red)
                        .cornerRadius(100)
                        .scaleEffect(scaleValue)
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                withAnimation(.spring()) {
                                    self.scaleValue = 0.8
                                }
                            }
                            .onEnded { gesture in
                                withAnimation(.spring()) {
                                    self.scaleValue = 1
                                }
                                if numberOfShares != "" && stockQuote.displayPrice > 0 {
                                    if let intNumberOfShares = Int(numberOfShares) {
                                        if intNumberOfShares > 0 {
                                            presentationMode.wrappedValue.dismiss()
                                            order.transactionType = transactionType
                                            order.sharePrice = stockQuote.displayPrice
                                            order.stockSymbol = stockQuote.symbol
                                            order.orderType = isMarket ? .market : .limit
                                            if !isMarket {
                                                if let doubleSharePrice = Double(sharePrice) {
                                                    if (transactionType == .buy && doubleSharePrice < stockQuote.displayPrice) || (transactionType == .sell && doubleSharePrice > stockQuote.displayPrice) {
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
                                }
                            })
                    Spacer()
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        if transactionType == .buy {
                            Text("Available Funds: \(data.funds.withCommas(withRupeeSymbol: true))")
                        }
                        Text("\(transactionType == .buy ? "Funds required" : "Sale Amount"): \(((Double(numberOfShares) ?? 0) * (Double(sharePrice) ?? 0)).withCommas(withRupeeSymbol: true))")
                    }
                    Spacer()
                    
                    if numberTextFieldFocused || priceTextFieldFocused || true {
                        Button(action: {
                            numberTextFieldFocused = false
                            priceTextFieldFocused = false
                        }) {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .font(.title2)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 11)
                .background(Color("Light Gray"))
            }
            .padding(.bottom, 1)
        }
        .onDisappear(perform: {
            numberTextFieldFocused = false
            presentationMode.wrappedValue.dismiss()
        })
        .onAppear(perform: {
            self.sharePrice = String(data.getStockQuote(stockSymbol: stockSymbol).displayPrice)
            print(data.getStockQuote(stockSymbol: stockSymbol).displayPrice)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                numberTextFieldFocused = true
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
            if stockQuote.displayPrice > 0 {
                return String(Int(data.funds/stockQuote.displayPrice*percent))
            }
        } else {
            let numberOfShares = data.getTotalSharesOwned(stockSymbol: stockSymbol)
            return String(Int(Double(numberOfShares)*percent))
        }
        return "0"
    }
}


struct TransactView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                TransactStockView(transactionType: .buy, stockSymbol: "RELIANCE", isFullScreen: true)
            }
        }
    }
}
