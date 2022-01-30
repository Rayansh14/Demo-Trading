//
//  Demo_TradingApp.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI

@main
struct Demo_TradingApp: App {
    
    @ObservedObject var data = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            // show error message here only. that way, it will be better and better and better and better and better and better and better
            ZStack {
                
                MainTabView()
                    .onAppear(perform: {
                        DataController.shared.getStocksData()
                        DataController.shared.loadData()

                    })
                
                VStack {
                    Spacer()
                    Button(action: {data.showMessage = false}) {
                        ErrorTileView()
                        
                    }
                    .padding(.bottom, 60)
                    .buttonStyle(BorderlessButtonStyle())
                    .opacity(data.showMessage ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: data.showMessage)
                }
            }
            
        }
    }
}
