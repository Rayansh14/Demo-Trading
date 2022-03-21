//
//  ContentView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        
        TabView {
            Guides()
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("Guides")
                }
            
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
            PortfolioView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Holdings")
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
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
