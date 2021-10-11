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
    @State private var buyValue = 0.0
    @State private var currentValue: Double = 0
    @State private var profitLoss: Double = 0
    @State private var profitLossPercent: Double = 0
    @State private var dayProfitLoss: Double = 0
    @State private var dayProfitLossPercent: Double = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text("\(buyValue.withCommas(withRupeeSymbol: false))")
                            Text("Invested Amount")
                                .font(.system(size: 15))
                        }
                        .offset(x: -5)
                        
                        Spacer()
                        
                        VStack {
                            Text("\(currentValue.withCommas(withRupeeSymbol: false))")
                            Text("Current Value")
                                .font(.system(size: 15))
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 2)
                    .font(.system(size: 30))
                    
                    Rectangle()
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                    
                    
                    HStack {
                        Text("P/L:")
                            .font(.title)
                        Spacer()
                        Text("\(String(profitLoss.withCommas(withRupeeSymbol: false)))")
                            .font(.title)
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                        Text("(\(String(profitLossPercent.withCommas(withRupeeSymbol: false)))%)")
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.vertical)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke())
                .padding()
                
                if (portfolioType == .holdings ? data.holdings : data.positions).count == 0 {
                    ZStack {
                        
                        Image("share-certificate-png")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color("Blue"))
                            .opacity(0.9)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .aspectRatio(contentMode: .fit)
                        VStack {
                            Spacer()
                            Spacer()
                        }
                        
                    }
                } else {
                    ScrollView {
                        VStack {
                            
                            ForEach(portfolioType == .holdings ? data.holdings : data.positions) {stock in
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("Divider Gray"))
                                PortfolioTileView(stock: stock)
                            }
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color("Divider Gray"))
                        }
                    }
                }
                
                
                if portfolioType == .holdings {
                        HStack {
                            Text("Day P/L:")
                                .padding(.leading, 18)
                            Spacer()
                            Text("\(dayProfitLoss.withCommas(withRupeeSymbol: true)) (\(dayProfitLossPercent.withCommas(withRupeeSymbol: false))%)")
                                .padding(8)
                                .padding(.trailing, 10)
                                .foregroundColor(dayProfitLoss >= 0 ? .green : .red)
                        }
                        .background(Color("Light Gray"))
                        .padding(.bottom, 1)
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
        dayProfitLossPercent = dayProfitLoss*100/buyValue
        if buyValue == 0 {
            dayProfitLossPercent = 0
        } else {
            profitLossPercent = portfolioInfo["profitLossPercent"]!
        }
    }
}


struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PortfolioListView(portfolioType: .holdings)
            PortfolioListView(portfolioType: .positions)
                .preferredColorScheme(.dark)
        }
    }
}
