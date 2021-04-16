//
//  Demo_TradingApp.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI

@main
struct Demo_TradingApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .onAppear(perform: {
                    DataController.shared.getStocksData()
                    DataController.shared.loadData()
                })
        }
    }
}
