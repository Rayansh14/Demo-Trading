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
            Text("The First Tab")
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Watchlist")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Holdings")
                }
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "location.fill")
                    Text("Positions")
                }
            Text("The Last Tab")
                .tabItem {
                    Image(systemName: "indianrupeesign.circle.fill")
                    Text("Funds")
                }
        }
//        ScrollView {
//            VStack {
//                if DataController.shared.stockQuotes.count == 0 {
//                    Text("No quotes to display")
//                        .bold()
//                        .padding()
//                        .padding(.bottom, 50)
//                        .multilineTextAlignment(.center)
//                } else {
//                    ForEach(DataController.shared.stockQuotes) { stockQuote in
//                        Text("1")
//                    }
//                }
//            }
//        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
