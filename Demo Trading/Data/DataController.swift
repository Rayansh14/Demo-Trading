//
//  DataController.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI
import SwiftDate

class DataController: ObservableObject {
    
    static var shared = DataController()
    @ObservedObject var monitor = NetworkMonitor()
    
    @Published var stockQuotes: [StockQuote] = []
    let stockQuotesOrder = ["RELIANCE", "HDFCBANK", "INFY", "HDFC", "ICICIBANK", "TCS", "KOTAKBANK", "HINDUNILVR", "AXISBANK", "ITC", "LT", "SBIN", "BAJFINANCE", "BHARTIARTL", "ASIANPAINT", "HCLTECH", "MARUTI", "M&M", "ULTRACEMCO", "SUNPHARMA", "WIPRO", "INDUSINDBK", "TITAN", "BAJAJFINSV", "NESTLEIND", "TATAMOTORS", "TECHM", "HDFCLIFE", "POWERGRID", "DRREDDY", "TATASTEEL", "NTPC", "BAJAJ-AUTO", "ADANIPORTS", "HINDALCO", "GRASIM", "DIVISLAB", "HEROMOTOCO", "ONGC", "CIPLA", "BRITANNIA", "JSWSTEEL", "BPCL", "EICHERMOT", "SHREECEM", "SBILIFE", "COALINDIA", "UPL", "IOC", "TATACONSUM"]
    
    @Published var portfolio: [StockOwned] = []
    var positions: [StockOwned] {
        return portfolio.filter { $0.timeBought > Date().dateAt(.startOfDay) }
    }
    var holdings: [StockOwned] {
        return portfolio.filter { $0.timeBought < Date().dateAt(.startOfDay) }
    }
    
    @Published var orderList: [Order] = []
    var todayOrders: [Order] {
        return orderList.filter { $0.time > Date().dateAt(.startOfDay) }.sorted { $0.time > $1.time }
    }
    var earlierOrders: [Order] {
        return orderList.filter { $0.time < Date().dateAt(.startOfDay) }.sorted { $0.time > $1.time }
    }
    
    @Published var funds: Double = 1_00_000.0
    
    @Published var showError = false
    @Published var errorMessage = ""
    
    
    func getMarketStatus() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let nineFifteenToday = calendar.date(bySettingHour: 9, minute: 14, second: 59, of: now)!
        let threeThirtyToday = calendar.date(bySettingHour: 15, minute: 30, second: 01, of: now)!
        
        print(nineFifteenToday)
        
        if now.compare(.isWeekday) {
            if now > nineFifteenToday && now < threeThirtyToday {
                return true
            }
        }
        return false
    }
    
    
    func getStocksData() {
        if monitor.isConnected {
            if let url = URL(string: "https://latest-stock-price.p.rapidapi.com/price?Indices=NIFTY%2050") {
                var request = URLRequest(url: url)
                request.addValue("7fb21cb036msh42efbbec95f083fp193e7bjsn0fc5005cafa3", forHTTPHeaderField: "x-rapidapi-key")
                request.addValue("latest-stock-price.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
                request.addValue("true", forHTTPHeaderField: "useQueryString")
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let webData = data {
                        if let json = try? JSONSerialization.jsonObject(with: webData, options: []) as? [[String:Any]] {
                            
                            var stockQuotesToAdd: [StockQuote] = []
                            
                            for jsonStockQuote in json {
                                let stockQuote = StockQuote()
                                
                                if let symbol = jsonStockQuote["symbol"] as? String {
                                    stockQuote.symbol = symbol
                                    print(symbol)
                                }
                                if let lastPrice = jsonStockQuote["lastPrice"] as? Double {
                                    stockQuote.lastPrice = lastPrice
                                }
                                if let change = jsonStockQuote["change"] as? Double {
                                    stockQuote.change = change
                                }
                                if let pChange = jsonStockQuote["pChange"] as? Double {
                                    stockQuote.pChange = pChange
                                }
                                if let dayHigh = jsonStockQuote["dayHigh"] as? Double {
                                    stockQuote.dayHigh = dayHigh
                                }
                                if let dayLow = jsonStockQuote["dayLow"] as? Double {
                                    stockQuote.dayLow = dayLow
                                }
                                if let previousClose = jsonStockQuote["previousClose"] as? Double {
                                    stockQuote.previousClose = previousClose
                                }
                                if let open = jsonStockQuote["open"] as? Double {
                                    stockQuote.open = open
                                }
                                if let totalTradedVolume = jsonStockQuote["totalTradedVolume"] as? Int {
                                    stockQuote.totalTradedVolume = totalTradedVolume
                                }
                                
                                stockQuotesToAdd.append(stockQuote)
                            }
                            DispatchQueue.main.async {
                                self.stockQuotes = stockQuotesToAdd
                            }
                        }
                    }
                }.resume()
            }
        } else {
            showErrorMessage(message: "Not connected to internet.")
        }
    }
    
    
    func updateAllStockPricesInPortfolio() {
        stockQuotes.append(StockQuote())
        for stock in portfolio {
            for quote in stockQuotes {
                if stock.stockSymbol == quote.symbol {
                    stock.lastPrice = quote.lastPrice
                    stock.dayChange = quote.change
                }
            }
        }
        saveData()
    }
    
    
    func checkIfOwned(stockSymbol: String) -> Bool {
        for stock in self.portfolio {
            if stock.stockSymbol == stockSymbol {
                return true
            }
        }
        return false
    }
    
    
    func getStockQuote(stockSymbol: String) -> StockQuote {
        for quote in stockQuotes {
            if quote.symbol == stockSymbol {
                return quote
            }
        }
        let newQuote = StockQuote()
        newQuote.symbol = "ERROR 1"
        return newQuote
    }
    
    
    func showErrorMessage(message: String) {
        errorMessage = message
        showError = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7)) {
            self.showError = false
        }
    }
    
    
    func getPorfolioInfo(portfolio: [StockOwned]) -> [String: Double] {
        var portfolioInfo: [String: Double] = [
            "buyValue" : 0.0,
            "currentValue" : 0.0,
            "profitLoss" : 0.0,
            "profitLossPercent" : 0.0,
            "dayProfitLoss" : 0.0
        ]
        for stock in portfolio {
            portfolioInfo["buyValue"]! += (stock.avgPriceBought * Double(stock.numberOfShares))
            portfolioInfo["currentValue"]! += (stock.lastPrice * Double(stock.numberOfShares))
            portfolioInfo["dayProfitLoss"]! += (Double(stock.numberOfShares) * stock.dayChange)
        }
        portfolioInfo["profitLoss"]! = portfolioInfo["currentValue"]! - portfolioInfo["buyValue"]!
        portfolioInfo["profitLossPercent"]! = portfolioInfo["profitLoss"]!/portfolioInfo["buyValue"]! * 100
        return portfolioInfo
    }
    
    
    func processOrder(order: Order) {
        if getMarketStatus() {
            if order.type == .buy {
                if funds >= (order.sharePrice * Double(order.numberOfShares)) {
                    orderList.append(order)
                    if checkIfOwned(stockSymbol: order.stockSymbol) {
                        for stock in portfolio {
                            if stock.stockSymbol == order.stockSymbol {
                                stock.avgPriceBought = (((stock.avgPriceBought * Double(stock.numberOfShares)) + (order.sharePrice * Double(order.numberOfShares)))/Double(order.numberOfShares + stock.numberOfShares))
                                stock.numberOfShares += order.numberOfShares
                                funds -= (order.sharePrice * Double(order.numberOfShares))
                            }
                        }
                    } else {
                        let stockOwned = StockOwned()
                        stockOwned.numberOfShares = order.numberOfShares
                        stockOwned.avgPriceBought = order.sharePrice
                        stockOwned.stockSymbol = order.stockSymbol
                        stockOwned.timeBought = order.time
                        portfolio.append(stockOwned)
                        funds -= (order.sharePrice * Double(order.numberOfShares))
                    }
                } else {
                    showErrorMessage(message: "Not enough funds! Sell some stocks or reduce the number of shares.")
                }
            } else {
                if checkIfOwned(stockSymbol: order.stockSymbol) {
                    for stock in portfolio {
                        if stock.stockSymbol == order.stockSymbol {
                            if stock.numberOfShares > order.numberOfShares {
                                orderList.append(order)
                                stock.numberOfShares -= order.numberOfShares
                                funds += (Double(order.numberOfShares) * order.sharePrice)
                            } else if stock.numberOfShares == order.numberOfShares {
                                orderList.append(order)
                                funds += (Double(order.numberOfShares) * order.sharePrice)
                                if let index = portfolio.firstIndex(where: {loopingStockOwned -> Bool in
                                    return loopingStockOwned.id == stock.id
                                }) {
                                    portfolio.remove(at: index)
                                }
                            } else {
                                showErrorMessage(message: "You don't own enough shares.")
                            }
                        }
                    }
                } else {
                    showErrorMessage(message: "You don't own any \(order.stockSymbol) shares.")
                }
            }
            saveData()
        } else {
            showErrorMessage(message: "The stock market is not open right now. Please try again when it is open.")
        }
    }
    
    
    func saveData() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            if let portfolioData = try? encoder.encode(self.portfolio) {
                if let orderListData = try? encoder.encode(self.orderList) {
                    if let fundsData = try? encoder.encode(self.funds) {
                        UserDefaults.standard.setValue(portfolioData, forKey: "portfolio")
                        UserDefaults.standard.setValue(orderListData, forKey: "orderList")
                        UserDefaults.standard.setValue(fundsData, forKey: "funds")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    
    func loadData() {
        DispatchQueue.global().async {
            if let portfolioData = UserDefaults.standard.data(forKey: "portfolio") {
                if let orderListData = UserDefaults.standard.data(forKey: "orderList") {
                    if let fundsData = UserDefaults.standard.data(forKey: "funds") {
                        let decoder = JSONDecoder()
                        if let jsonPortfolio = try? decoder.decode([StockOwned].self, from: portfolioData) {
                            if let jsonOrderList = try? decoder.decode([Order].self, from: orderListData) {
                                if let jsonFunds = try? decoder.decode(Double.self, from: fundsData) {
                                    DispatchQueue.main.async {
                                        self.portfolio = jsonPortfolio
                                        self.orderList = jsonOrderList
                                        self.funds = jsonFunds
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func resetAll() {
        self.portfolio = []
        self.orderList = []
        self.funds = 1_00_000.0
        saveData()
    }
}


extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSize = 3
        numberFormatter.secondaryGroupingSize = 2
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
