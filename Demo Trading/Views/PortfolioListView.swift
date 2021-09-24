//
//  PortfolioListView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 19/04/21.
//

import SwiftUI

enum PortfolioType: String {
    case holdings, positions
}

struct PortfolioListView: View {
    
    @ObservedObject var data = DataController.shared
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    var portfolioType: PortfolioType
    @State var buyValue = 0.0
    @State var currentValue: Double = 0
    @State var profitLoss: Double = 0
    @State var profitLossPercent: Double = 0
    @State var dayProfitLoss: Double = 0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack {
                        Text("\(buyValue.withCommas(withRupeeSymbol: false))")
                        Text("\(currentValue.withCommas(withRupeeSymbol: false))")
                    }
                    .font(.title)
                    VStack {
                        Text("\(String(format: "%.2f", profitLoss))")
                            .font(.largeTitle)
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                        Text("\(String(format: "%.2f", profitLossPercent))%")
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                        if portfolioType == .holdings {
                            Text("\(dayProfitLoss.withCommas(withRupeeSymbol: true))")
                        }
                    }
                }
                
                ScrollView {
                    VStack {
                        if (portfolioType == .holdings ? data.holdings : data.positions).count == 0 {
                            Text("Nothing to see here 👀")
                        } else {
                            ForEach(portfolioType == .holdings ? data.holdings : data.positions) {stock in
                                Divider()
                                PortfolioTileView(stock: stock)
                            }
                            Divider()
                        }
                    }
                }
            }
            .navigationTitle(portfolioType == .holdings ? "Holdings" : "Positions")
            .navigationBarItems(trailing: Button(action: {
                updateAllPortfolioData()
            }) {
                Image(systemName: "gobackward")
            })
        }
        .onReceive(timer, perform: { _ in
            updateAllPortfolioData()
        })
        .onAppear(perform: {
            updateAllPortfolioData()
        })
    }
    
    func updateAllPortfolioData() {
        data.updateAllStockPricesInPortfolio()
        let portfolioInfo = data.getPorfolioInfo(portfolio: portfolioType == .holdings ? data.holdings : data.positions)
        buyValue = portfolioInfo["buyValue"]!
        currentValue = portfolioInfo["currentValue"]!
        profitLoss = portfolioInfo["profitLoss"]!
        dayProfitLoss = portfolioInfo["dayProfitLoss"]!
        if buyValue > 0.0 {
            profitLossPercent = portfolioInfo["profitLossPercent"]!
        } else {
            profitLossPercent = 0.00
        }
    }
}


struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PortfolioListView(portfolioType: .holdings)
            VStack {
                Divider()
                PortfolioTileView(stock: testStockOwned)
                Divider()
            }
        }
    }
}
