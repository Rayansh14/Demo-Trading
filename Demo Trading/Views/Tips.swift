//
//  Tips.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 30/09/21.
//

import SwiftUI

struct TipsView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        ZStack {
            TabView {
                TipsPageView(title: "Welcome!", text: "Welcome to Demo Trading! This app is meant to help you get started with investing in the stock market 💸. You have been given ₹1 lakh in fantasy money to buy and sell stocks of your choice! 🙃. Read on to get an idea for how this app, and the stock market in general works.", imageName: "", alignment: TextAlignment.center)
                
                TipsPageView(title: "Watchlist 👀", text: "This is your watchlist tab. You can add stocks to your watchlist by tapping on the search bar and searching for them. Once you've added stocks, they will appear on your watchlist. You can tap on a stock to get details about that stock and also trade (buy or sell) it.", imageName: "watchlist-1")
                
                TipsPageView(title: "Orders", text: "This is your orders tab. You can see all your transactions over here. You can also see details about your transaction, like type (buy or sell), number of shares, share price, time, etc.", imageName: "t")
                
                TipsPageView(title: "Holdings", text: "This is your holdings tab. Stocks that you have been holding for more than a day will appear here. You can see details about the stocks that you've been holding over here. If this is not empty, then you have been using this app for more than a day. 🤩🙃", imageName: "t")
                
                TipsPageView(title: "Positions", text: "This is your positions tab. Stocks that you buy will appear here on the day that they are bought. Go to your watchlist, tap on a stock and buy it to get started!", imageName: "positions")
                
                TipsPageView(title: "Funds", text: "This page shows the funds that you have available to buy new stocks. It also shows other details like the delivery margin and total net worth.", imageName: "funds")
                
                TipsPageView(title: "Delivery Margin", text: "as per guideline, 20 percent is blocked, can be accessed next day. implemented this feature to make the app more realistic.", imageName: "t")
                
                TipsPageView(title: "Ready, Get Set, Go!", text: "now you know all the basics, start your journey on the stock maket, hopefully more ups and less downs,", imageName: "t")
                
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .navigationTitle("Welcome!")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct TipsPageView: View {
    
    var title: String
    var text: String
    var imageName: String
    var alignment: TextAlignment = .leading
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if imageName != "" {
                HStack {
                    Spacer()
                    
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            HStack {
                
                if alignment == .center {
                    Spacer()
                }
                
                Text("\(title)")
                    .font(.title)
                
                if title.lowercased().contains("watchlist") {
                    Image(systemName: "list.bullet")
                        .imageScale(.large)
                        .offset(x: -5, y: -1)
                
                    Spacer()
                    
                }
                Spacer()
            }
            Text(text)
                .multilineTextAlignment(alignment)
            
            if imageName == "" {
                Spacer()
            }
            
        }
        .padding(15)
        .padding(.horizontal, 5)
        .padding(.bottom, 30)
    }
}


struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                TipsView()
                    .preferredColorScheme(.dark)
            }
        }
    }
}
