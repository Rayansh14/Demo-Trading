//
//  ContentView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var data = DataController.shared
//    private let timer = Timer.publish(every: 30, tolerance: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        TabView {
            WatchlistView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Watchlist")
                }
            OrdersView()
                .tabItem {
                    Image(systemName: "text.book.closed")
                    Text("Orders")
                }
            PortfolioListView(portfolioType: .holdings)
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Holdings")
                }
            PortfolioListView(portfolioType: .positions)
                .tabItem {
                    Image(systemName: "location.fill")
                    Text("Positions")
                }
            FundsView()
                .tabItem {
                    Image(systemName: "indianrupeesign.circle.fill")
                    Text("Funds")
                }
        }
        .onAppear {
            data.getStocksData()
        }
//        .onReceive(timer, perform: { _ in
//            if data.getMarketStatus() {
//                data.getStocksData()
//            }
//        })
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
