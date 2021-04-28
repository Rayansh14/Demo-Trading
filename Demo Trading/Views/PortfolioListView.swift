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
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    var portfolioType: PortfolioType
    @State var buyValue = 0.0
    @State var currentValue: Double = 0
    @State var profitLoss: Double = 0
    @State var profitLossPercent: Double = 0
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack {
                        Text("\(String(format: "%.2f", buyValue))")
                        Text("\(String(format: "%.2f", currentValue))")
                    }
                    .font(.title)
                    VStack {
                        Text("\(String(format: "%.2f", profitLoss))")
                            .font(.largeTitle)
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                        Text("\(String(format: "%.2f", profitLossPercent))%")
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
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
                updateAllData()
            }) {
                Image(systemName: "gobackward")
            })
        }
        .onReceive(timer, perform: { _ in
            updateAllData()
        })
        .onAppear(perform: {
            updateAllData()
        })
    }
    
    func updateAllData() {
        data.updateStockPrices()
        let portfolioInfo = data.getPorfolioInfo(portfolio: portfolioType == .holdings ? data.holdings : data.positions)
        buyValue = portfolioInfo["buyValue"]!
        currentValue = portfolioInfo["currentValue"]!
        profitLoss = portfolioInfo["profitLoss"]!
        if buyValue > 0.0 {
            profitLossPercent = portfolioInfo["profitLossPercent"]!
        } else {
            profitLossPercent = 0.00
        }
    }
}


struct PortfolioTileView: View {
    
    var stock: StockOwned
    @State var profitLoss: Double = 0.0
    @State var profitLossPercent: Double = 0.0
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        NavigationLink(destination: StockDetailView(stockQuote: data.getStockQuote(stockSymbol: stock.stockSymbol))) {
            HStack {
                
                VStack {
                    HStack {
                        Text("Avg: \(String(format: "%.2f", stock.avgPriceBought))")
                            .font(.system(size: 16))
                        Spacer()
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0.2002688944, green: 0.2002688944, blue: 0.2002688944, alpha: 1)))
                    HStack {
                        Text(stock.stockSymbol)
                            .font(.system(size: 21))
                            .frame(height: 32)
                        Spacer()
                    }
                    HStack {
                        Text("Qty: \(stock.numberOfShares)")
                            .font(.system(size: 16))
                        Spacer()
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0.2002688944, green: 0.2002688944, blue: 0.2002688944, alpha: 1)))
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    HStack {
                        Spacer()
                        Text("\(String(format: "%.2f", profitLossPercent))%")
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                            .font(.system(size: 16))
                    }
                    HStack {
                        Spacer()
                        Text("\(profitLoss >= 0 ? "+" : "") \(String(format: "%.2f", profitLoss))")
                            .font(.system(size: 22))
                            .frame(height: 32)
                            .foregroundColor(profitLoss >= 0 ? .green : .red)
                    }
                    
                    HStack {
                        Spacer()
                        Text("LTP. \(String(format: "%.2f", stock.lastPrice))")
                            .font(.system(size: 16))
                            .foregroundColor(Color(#colorLiteral(red: 0.2002688944, green: 0.2002688944, blue: 0.2002688944, alpha: 1)))
                    }
                }
                .padding(.horizontal)
                
            }
            .foregroundColor(Color("Black White")) // without this, text colour is blue
        }
        .onAppear(perform: {
            updateProfitLoss()
        })
    }
    
    func updateProfitLoss() {
        profitLoss = (stock.lastPrice * Double(stock.numberOfShares)) - (stock.avgPriceBought * Double(stock.numberOfShares))
        profitLossPercent = profitLoss/(stock.avgPriceBought * Double(stock.numberOfShares)) * 100
    }
}


struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {PortfolioListView(portfolioType: .positions)
            VStack {
                Divider()
                PortfolioTileView(stock: testStockOwned)
                Divider()
            }
        }
    }
}
