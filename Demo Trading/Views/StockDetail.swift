//
//  StockDetailView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct StockDetailView: View {
    
    var stockSymbol = ""
    var isFullScreen = false
    var stockQuote = StockQuote()
    
    init(stockSymbol: String, isFullScreen: Bool) {
        self.stockSymbol = stockSymbol
        self.isFullScreen = isFullScreen
        self.stockQuote = data.getStockQuote(stockSymbol: stockSymbol)
        if let owned = data.getStockOwned(stockSymbol: stockSymbol) {
            self.stockOwned = owned
        }
    }
    
    @ObservedObject var data = DataController.shared
    var stockOwned = StockOwned()
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        ZStack {
            
            VStack {
                if !isFullScreen {
                    Spacer()
                }
                HStack {
                    VStack {
                        Text("NSE: \(stockQuote.lastPrice.withCommas(withRupeeSymbol: true))")
                        Text("\(Image(systemName: stockQuote.change >= 0 ? "arrow.up" : "arrow.down")) \(abs(stockQuote.pChange).withCommas(withRupeeSymbol: false))%")
                            .foregroundColor(stockQuote.pChange >= 0.0 ? .green : .red)
                            .font(.title3)
                    }
                    Spacer()
                    if data.checkIfOwned(stockSymbol: stockQuote.symbol) {
                        Text("\(Image(systemName: "briefcase.fill")) \(stockOwned.numberOfShares)")
                    }
                }
                .padding(.horizontal, 35)
                .padding(.top, 15)
                .font(.title2)
                
                
                HStack {
                    
                    HStack {
                        Spacer()
                        InfoView(text: "Open", info: stockQuote.open)
                        Spacer()
                        
                        CustomDivider()
                    }
                    
                    HStack {
                        Spacer()
                        InfoView(text: "Low", info: stockQuote.dayLow)
                        Spacer()
                        
                        CustomDivider()
                    }
                    
                    HStack {
                        Spacer()
                        InfoView(text: "High", info: stockQuote.dayHigh)
                        Spacer()
                        
                        CustomDivider()
                    }
                    
                    HStack {
                        Spacer()
                        InfoView(text: "Prev. Close", info: stockQuote.previousClose)
                        Spacer()
                    }
                    
                }
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                
                if !isFullScreen {
                    Spacer()
                }
                
                
                if !(stockQuote.symbol.contains("NIFTY")) {
                    
                    HStack {
                        NavigationLink(destination: TransactStockView(orderType: .buy, stockSymbol: stockSymbol, isFullScreen: isFullScreen)) {
                            TransactButton(text: "Buy", color: .green)
                        }
                        NavigationLink(destination: TransactStockView(orderType: .sell, stockSymbol: stockSymbol, isFullScreen: isFullScreen)) {
                            TransactButton(text: "Sell", color: .red)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    if isFullScreen {
                        
                        VStack {
                            CustomInfoView(label: "Buy Value:", info: ((stockOwned.avgPriceBought * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true)))
                                .padding(.top)
                            
                            CustomInfoView(label: "Current Value:", info: ((stockOwned.lastPrice * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true)))
                                .padding(.top, 1)
                            
                            CustomInfoView(label: "Profit/Loss:", info: ((stockOwned.lastPrice - stockOwned.avgPriceBought) * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true))
                                .padding(.top, 1)
                            
                            CustomInfoView(label: "Weightage in Portfolio:", info: "\((stockOwned.lastPrice * 100 * Double(stockOwned.numberOfShares) / data.getPorfolioInfo(portfolio: data.portfolio)["currentValue"]!).withCommas(withRupeeSymbol: false))%")
                                .padding(.top, 1)
                            CustomInfoView(label: "Last update time:", info: stockQuote.updateTimeAsString())
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
        .if({
            isFullScreen
        }()) { view in
            view.navigationTitle(stockSymbol)
        }
        .if({
            !isFullScreen
        }()) { view in
            view.navigationBarHidden(true)
        }
    }
}


struct TransactButton: View {
    
    var text: String
    var color: Color
    
    var body: some View {
        Text(text)
            .frame(width: 150)
            .foregroundColor(.white)
            .font(.system(size: 24))
            .padding(.vertical, 12)
            .background(color)
            .cornerRadius(100)
            .padding(.horizontal, 1)
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
        .font(.system(size: 16))
        .padding(.horizontal)
    }
}



struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StockDetailView(stockSymbol: "RELIANCE", isFullScreen: true)
            //                .preferredColorScheme(.dark)
        }
    }
}

struct InfoView: View {
    
    var text: String
    var info: Double
    
    var body: some View {
        VStack {
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(Color("Gray"))
                .offset(x: 0, y: -3)
            Text(info.withCommas(withRupeeSymbol: false))
                .offset(x: 0, y: 3)
                .font(.system(size: 15.5))
        }
    }
}

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(width: 1, height: 70)
            .foregroundColor(Color("Divider Gray"))
    }
}
