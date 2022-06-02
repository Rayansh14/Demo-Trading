//
//  StockDetailView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct StockDetailView: View {
    
    var isFullScreen = false
    var stockQuote = StockQuote()
    var stockOwned = StockOwned()
    @ObservedObject var data = DataController.shared
    
    init(stockSymbol: String, isFullScreen: Bool, portfolioType: PortfolioType = .holdings) {
        self.isFullScreen = isFullScreen
        self.stockQuote = data.getStockQuote(stockSymbol: stockSymbol)
        if let owned = data.getStockOwned(stockSymbol: stockSymbol, portfolioType: portfolioType) {
            self.stockOwned = owned
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
//        NavigationView {
            VStack(spacing: 10) {
                
                if !isFullScreen {
                    Spacer()
                } else {
                    HStack {
                        Text(stockQuote.symbol) // not lowercasing it because then it looks weird for stock names like Kalpatpowr
                            .font(.custom("Poppins-Regular", size: 31))
                            .padding(.leading)
                        Spacer()
                    }
                }
                
                HStack {
                    VStack {
                        Text("NSE: \(stockQuote.displayPrice.withCommas(withRupeeSymbol: true))")
                        Text("\(Image(systemName: stockQuote.change >= 0 ? "arrow.up" : "arrow.down")) \(abs(stockQuote.pChange).withCommas())%")
                            .foregroundColor(stockQuote.pChange >= 0.0 ? .green : .red)
                    }
                    Spacer()
                    if data.checkIfOwned(stockSymbol: stockQuote.symbol) {
                        Text("\(Image(systemName: "briefcase.fill")) \(stockOwned.numberOfShares)")
                    }
                }
                .padding(.horizontal, 35)
                .padding(.top, isFullScreen ? 0 : 5)
                .font(.custom("Poppins-Light", size: 21))
                
                
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
                .font(.custom("Poppins-Light", size: 16))
                .multilineTextAlignment(.center)
                
                if !isFullScreen {
                    Spacer()
                }
                
                
                if !(stockQuote.symbol.contains("NIFTY")) {
                    
                    HStack {
                        NavigationLink(destination: TransactStockView(transactionType: .buy, stockSymbol: stockQuote.symbol, isFullScreen: isFullScreen)) {
                            TransactButton(text: "Buy", color: .green)
                        }
                        NavigationLink(destination: TransactStockView(transactionType: .sell, stockSymbol: stockQuote.symbol, isFullScreen: isFullScreen)) {
                            TransactButton(text: "Sell", color: .red)
                        }
                    }
                    .padding(.vertical, 10)
                    
                    if isFullScreen {
                        
                        if data.checkIfInHoldings(stockSymbol: stockQuote.symbol) { // this is so that it doesn't display incorrect information when user accesses it by tapping on a positions tile.
                            CustomInfoView(label: "Today's P/L:", info: "\(stockQuote.change > 0 ? "+" : "") \((stockQuote.change * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true))")
                                .padding(.top)
                        }
                        
                        CustomInfoView(label: "Invested Value:", info: stockOwned.investedAmt.withCommas(withRupeeSymbol: true))
                        
                        CustomInfoView(label: "Current Value:", info: ((stockQuote.displayPrice * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true)))
                        
                        CustomInfoView(label: "Profit/Loss:", info: ((stockQuote.displayPrice - stockOwned.avgPriceBought) * Double(stockOwned.numberOfShares)).withCommas(withRupeeSymbol: true))
                        
                        CustomInfoView(label: "Weightage in Portfolio:", info: "\((stockQuote.displayPrice * 100 * Double(stockOwned.numberOfShares) / (data.portfolioInfo[0]["currentValue"]! + data.portfolioInfo[1]["currentValue"]!)).withCommas())%")
                        
                    }
                }
                CustomInfoView(label: "Last update time:", info: stockQuote.updateTimeAsString())
                    .padding(.top, 1)
                    .padding(.bottom, 15)
                
                Spacer()
            }
        .onDisappear(perform: {
            self.presentationMode.wrappedValue.dismiss()
        })
        //        .if({
        //            isFullScreen
        //        }()) { view in
        //            view.navigationTitle(stockSymbol.capitalized)
        //        }
        .navigationBarTitleDisplayMode(.inline)
        .if({
            !isFullScreen
        }()) { view in
            view.navigationBarHidden(true)
        }
    }
//}


struct TransactButton: View {
    
    var text: String
    var color: Color
    
    var body: some View {
        Text(text)
            .frame(width: 150)
            .foregroundColor(.white)
            .font(.custom("Poppins-Light", size: 24))
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
        .font(.custom("Poppins-Light", size: 16))
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
                .font(.custom("Poppins-Light", size: 15))
                .foregroundColor(Color("Gray"))
                .offset(x: 0, y: -3)
            Text(info.withCommas())
                .offset(x: 0, y: 3)
                .font(.custom("Poppins-Light", size: 15.5))
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
}
