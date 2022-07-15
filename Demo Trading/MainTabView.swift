//
//  ContentView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var data = DataController.shared
    @State var counter = 0
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    Text("Portfolio")
                }
            FundsView()
                .tabItem {
                    Image(systemName: "indianrupeesign.circle.fill")
                    Text("Funds")
                }
        }
        .onReceive(timer, perform: { _ in
            data.randomIncrement()
            
            counter += 1
            if counter >= 15 {
                data.getStocksData()
                counter  = 0
            }
        })
        .onAppear {
            let appearence = UITabBarAppearance()
            appearence.configureWithOpaqueBackground()
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearence // otherwise tab bar becomes transparent when scrolled to bottom
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
