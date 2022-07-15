//
//  GettingStartedGuide.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 27/04/22.
//

import SwiftUI

struct GettingStartedGuide: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        TabView {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Welcome!")
                            .font(heading1)
                        Image("loading")
                            .guideImagePadding()
                        Text("Welcome to Demo Trading! This app is meant to help you get started with investing in the stock market 💸. You have been given ₹1 lakh in fantasy money to buy and sell stocks of your choice! 🙃. Read on to get an idea for how this app, and the stock market in general works.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Guides")
                            .font(heading1)
                        Image("")
                        Text("This is your guides tab. It has various explainers that will help you to understand different aspects of the stock market. For example, it has guides on fundamental analysis, technical analysis, etc. Each guide is divided into chapters containing 4-6 pages each, including multiple quizzes to test your learning.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Watchlist")
                            .font(heading1)
                        Image("watchlist-1")
                            .guideImagePadding()
                        Text("This is your watchlist tab. You can view the latest quotes (prices) of stocks you want over here. Add stocks to your watchlist by tapping on the search bar and searching for them.\n\nYou can tap on a stock to get details about that stock and also trade (buy or sell) it.\nDay High - This is the highest price the stock has traded at on a particular day.\nDay Low - This is the lowest price the stock has traded at on a particular day.\nPrev Close - This is the price at which the stock ended the previous day. It is the price of the last transaction executed on the day before.\nOpen - This is the price at which the stock starts trading on a particular day. It is the price of the first transaction of the day.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Transacting")
                            .font(heading1)
                        Text("Tapping on the buy/sell buttons will take you to the transaction page. Here, you have got a couple of options, which we will get into.\n\nMarket orders are executed at the current market price while limit orders are executed at a specified price. A market order typically ensures an execution, but there it does not guarantee a specific price. A limit order does not ensure an execution, but if the order is executed, it is guaranteed to be at the price that you have set.\nThere are also various percentage buttons like 25%, 50%, etc. These are for your convenience when placing an order.\nIn a buy transaction, you can tap on these buttons to use a certain percentage of your funds in the order. Similarly, in a sell transaction, you can tap on these buttons to sell a certain percentage of the shares you own of that particular company.")
                        
                        HStack {
                            CustomRectangleLeft()
                            VStack(alignment: .leading) {
                                Text("Example")
                                    .font(heading2)
                            Text("I have Rs. 10,000 as available funds and want to use 25% to buy SBI shares, which are currently trading at Rs. 500. I can simply tap on the 25% button and it will automatically show 5 in the quantity field, since 25% of my available funds (Rs. 10,000) is Rs. 2500 and 2500 ÷ 500 = 5.")
                            }
                        }
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Orders")
                            .font(heading1)
                        Text("This is your orders tab. You can see all your transactions over here. You can also see details about your transaction, like type (buy or sell), number of shares, share price, time, etc.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Portfolio")
                            .font(heading1)
                        Image("positions")
                            .guideImagePadding()
                        Text("This is your portfolio tab. It consists of two parts - positions and holdings.\n\nThis is the positions section. Stocks that you buy will appear here on the day that they are bought. You can also see details about your stocks like average price bought, number of shares owned, profit/loss, etc. Go to your watchlist, tap on a stock and buy it to get started!\n\nThis is the holdings section. Stocks that you have been holding for more than a day will appear here. You can also see the overall details of your holdings, like total invested amount and profit/loss. If this is not empty, then you have been using this app for more than a day.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Funds")
                            .font(heading1)
                        Image("funds")
                            .guideImagePadding()
                        Text("This page shows the funds that you have available to buy new stocks. It also shows other details like the delivery margin and total net worth.")
                    }
                    .guidePadding()
                }
        }
        .applyGuideChars()
        .onAppear {
            data.isFirstTime = false
            data.saveData()
        }
    }
}

extension Image {
    func guideImagePadding() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 50)
            .padding(.bottom)
    }
}
    

struct GettingStartedGuide_Previews: PreviewProvider {
    static var previews: some View {
        GettingStartedGuide()
    }
}
