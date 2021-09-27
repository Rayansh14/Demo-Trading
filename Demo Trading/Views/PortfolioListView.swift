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
    @State var dayProfitLossPercent: Double = 0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack {
                        Text("\(buyValue.withCommas(withRupeeSymbol: false))")
                        Text("Invested Amount")
                            .font(.system(size: 15.5))
                            .padding(.bottom, 1)
                        Text("\(currentValue.withCommas(withRupeeSymbol: false))")
                        Text("Current Value")
                            .font(.system(size: 15.5))
                    }
                    .font(.title)
                    
                    Rectangle()
                        .frame(width: 1, height: 160)
                    
                    VStack {
                        Text("P/L:")
                            .font(.title)
                        Text("\(String(profitLoss.withCommas(withRupeeSymbol: false)))")
                            .font(.title)
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                        Text("\(String(profitLossPercent.withCommas(withRupeeSymbol: false)))%")
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                    }
                }
                .padding(.horizontal, 15)
                .border(Color.black, width: 1)
                
                
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
                
                
                if portfolioType == .holdings {
                    HStack {
                        Text("Day P/L:")
                            .padding(.leading, 10)
                            .padding(.leading, 8)
                        Spacer()
                        Text("\(dayProfitLoss.withCommas(withRupeeSymbol: true)) (\(dayProfitLossPercent.withCommas(withRupeeSymbol: false))%)")
                            .padding(8)
                            .padding(.trailing, 10)
                            .foregroundColor(dayProfitLoss >= 0 ? .green : .red)
                    }
                    .background(Color("Light Gray"))
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
//                data.updateAllStockPricesInPortfolio()
//                let portfolioInfo = data.getPorfolioInfo(portfolio: portfolioType == .holdings ? data.holdings : data.positions)
//                buyValue = portfolioInfo["buyValue"]!
//                currentValue = portfolioInfo["currentValue"]!
//                profitLoss = portfolioInfo["profitLoss"]!
//                dayProfitLoss = portfolioInfo["dayProfitLoss"]!
//                dayProfitLossPercent = dayProfitLoss*100/buyValue
//                if buyValue > 0.0 {
//                    profitLossPercent = portfolioInfo["profitLossPercent"]!
//                } else {
//                    profitLossPercent = 0.00
//                }
    }
}


struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PortfolioListView(portfolioType: .holdings, buyValue: 82069.06, currentValue: 83194.40, profitLoss: 874.66, profitLossPercent: 1.07, dayProfitLoss: 517.85, dayProfitLossPercent: 0.73)
        }
    }
}
