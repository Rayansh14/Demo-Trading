//
//  ContentView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            WatchlistView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Watchlist")
                }
            HoldingsView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Holdings")
                }
            PositionsView()
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
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
