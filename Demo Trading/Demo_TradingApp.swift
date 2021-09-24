//
//  Demo_TradingApp.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI
import SwiftDate

@main
struct Demo_TradingApp: App {
    
    @ObservedObject var data = DataController.shared
    var date = Date()
    var laterdate = Date() + 13.hours
    
    var body: some Scene {
        WindowGroup {
            // show error message here only. that way, it will be better and better and better and better and better and better and better
            ZStack {
                
                MainTabView()
                    .onAppear(perform: {
                        print(Date().dateAt(.endOfDay) > laterdate)
                        print(date > laterdate)
                        DataController.shared.getStocksData()
                        DataController.shared.loadData()
                    })
                
                VStack {
                    Spacer()
                    Button(action: {data.showError = false}) {
                        ErrorTileView(error: data.errorMessage)
                        
                    }
                    .padding(.bottom, 60)
                    .buttonStyle(BorderlessButtonStyle())
                    .opacity(data.showError ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3))
                }
            }
            
        }
    }
}
