//
//  DataController.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI
import SwiftDate
import UIKit

class DataController: ObservableObject {
    
    static var shared = DataController()
    @ObservedObject var monitor = NetworkMonitor()
    
    @Published var showTab = true
    
    @Published var stockQuotes: [StockQuote] = []
    @Published var userStocksOrder: [String] = []
//    "RELIANCE", "HDFCBANK", "INFY", "HDFC", "ICICIBANK", "TCS", "KOTAKBANK", "HINDUNILVR", "AXISBANK", "ITC", "LT"
    //    let userStocksOrder = ["RELIANCE", "HDFCBANK", "INFY", "HDFC", "ICICIBANK", "TCS", "KOTAKBANK", "HINDUNILVR", "AXISBANK", "ITC", "LT", "SBIN", "BAJFINANCE", "BHARTIARTL", "ASIANPAINT", "HCLTECH", "MARUTI", "M&M", "ULTRACEMCO", "SUNPHARMA", "WIPRO", "INDUSINDBK", "TITAN", "BAJAJFINSV", "NESTLEIND", "TATAMOTORS", "TECHM", "HDFCLIFE", "POWERGRID", "DRREDDY", "TATASTEEL", "NTPC", "BAJAJ-AUTO", "ADANIPORTS", "HINDALCO", "GRASIM", "DIVISLAB", "HEROMOTOCO", "ONGC", "CIPLA", "BRITANNIA", "JSWSTEEL", "BPCL", "EICHERMOT", "SHREECEM", "SBILIFE", "COALINDIA", "UPL", "IOC", "TATACONSUM"]
    
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
    
    @Published var deliveryMargin: [Date: Double] = [:]
    
    @Published var showMessage = false
    @Published var message = ""
    @Published var isError = true
    
    
    func getMarketStatus() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let nineFifteenToday = calendar.date(bySettingHour: 9, minute: 14, second: 59, of: now)!
        let threeThirtyToday = calendar.date(bySettingHour: 15, minute: 30, second: 00, of: now)!
        
        
        if now.compare(.isWeekday) {
            if now > nineFifteenToday && now < threeThirtyToday {
                return true
            }
        }
        return false
    }
    
    
    func getStocksData() {
        if monitor.isConnected {
            if let url = URL(string: "https://latest-stock-price.p.rapidapi.com/any") {
                var request = URLRequest(url: url)
                request.addValue("03512222b0mshcad312769b45365p140f7ajsnf9fbe4c10a7e", forHTTPHeaderField: "x-rapidapi-key")
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
                                if stockQuotesToAdd.count != 0 {
                                    self.stockQuotes = stockQuotesToAdd
                                }
                            }
                        }
                    }
                }.resume()
            }
        } else {
            showMessage(message: "Not connected to internet.")
        }
    }
    
    
    func getStockOwned(stockSymbol: String) -> StockOwned {
        if let index = portfolio.firstIndex(where: {loopingStockOwned -> Bool in
            return loopingStockOwned.stockSymbol == stockSymbol
        }) {
            return portfolio[index]
        }
        return StockOwned()
    }
    
    
    func updateAllStockPricesInPortfolio() {
        for stock in portfolio {
            for quote in stockQuotes {
                if stock.stockSymbol == quote.symbol {
                    stock.lastPrice = quote.lastPrice
                    stock.dayChange = quote.change
                    stock.dayPChange = quote.pChange
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
    
    
    func checkIfInHoldings(stockSymbol: String) -> Bool {
        for stock in self.holdings {
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
    
    
    func showMessage(message: String, error: Bool = true) {
        self.message = message
        self.isError = error
        showMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7)) {
            self.showMessage = false
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
                    funds -= (order.sharePrice * Double(order.numberOfShares))
                    if checkIfOwned(stockSymbol: order.stockSymbol) {
                        for stock in portfolio {
                            if stock.stockSymbol == order.stockSymbol {
                                stock.avgPriceBought = (((stock.avgPriceBought * Double(stock.numberOfShares)) + (order.sharePrice * Double(order.numberOfShares)))/Double(order.numberOfShares + stock.numberOfShares))
                                stock.numberOfShares += order.numberOfShares
                            }
                        }
                    } else {
                        let stockOwned = StockOwned()
                        stockOwned.numberOfShares = order.numberOfShares
                        stockOwned.avgPriceBought = order.sharePrice
                        stockOwned.stockSymbol = order.stockSymbol
                        stockOwned.timeBought = order.time
                        portfolio.append(stockOwned)
                    }
                    
                    showMessage(message: "Done! And you still have \(self.funds.withCommas(withRupeeSymbol: true)) left.", error: false)
                } else {
                    showMessage(message: "Not enough funds! Sell some stocks or reduce the number of shares.")
                }
            } else {
                if checkIfOwned(stockSymbol: order.stockSymbol) {
                    for stock in portfolio {
                        if stock.stockSymbol == order.stockSymbol {
                            if stock.numberOfShares >= order.numberOfShares {
                                orderList.append(order)
                                
                                if stock.numberOfShares == order.numberOfShares {
                                    if let index = portfolio.firstIndex(where: {loopingStockOwned -> Bool in
                                        return loopingStockOwned.id == stock.id
                                    }) {
                                        portfolio.remove(at: index)
                                    }
                                } else {
                                    stock.numberOfShares -= order.numberOfShares
                                }
                                
                                if checkIfInHoldings(stockSymbol: stock.stockSymbol) {
                                    funds += (Double(order.numberOfShares) * order.sharePrice) * 0.8
                                    let date = Date() + 5.hours + 30.minutes + 1.days
                                    self.deliveryMargin[date] = Double(order.numberOfShares) * order.sharePrice * 0.2
                                    
                                } else {
                                    funds += (Double(order.numberOfShares) * order.sharePrice)
                                }
                            } else {
                                showMessage(message: "You don't own enough shares.")
                            }
                        }
                    }
                } else {
                    showMessage(message: "You don't own any \(order.stockSymbol) shares.")
                }
            }
            saveData()
        } else {
            showMessage(message: "The stock market is not open right now. Please try again when it is open.")
        }
    }
    
    
    func saveData() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            if let portfolioData = try? encoder.encode(self.portfolio) {
                if let orderListData = try? encoder.encode(self.orderList) {
                    if let fundsData = try? encoder.encode(self.funds) {
                        if let userStocksOrderData = try? encoder.encode(self.userStocksOrder) {
                            if let deliveryMarginData = try? encoder.encode(self.deliveryMargin) {
                                UserDefaults.standard.setValue(portfolioData, forKey: "portfolio")
                                UserDefaults.standard.setValue(orderListData, forKey: "orderList")
                                UserDefaults.standard.setValue(fundsData, forKey: "funds")
                                UserDefaults.standard.setValue(userStocksOrderData, forKey: "userStocksOrder")
                                UserDefaults.standard.setValue(deliveryMarginData, forKey: "deliveryMargin")
                            }
                        }
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
                        if let userStocksOrderData = UserDefaults.standard.data(forKey: "userStocksOrder") {
                            if let deliveryMarginData = UserDefaults.standard.data(forKey: "deliveryMargin") {
                                let decoder = JSONDecoder()
                                if let jsonPortfolio = try? decoder.decode([StockOwned].self, from: portfolioData) {
                                    if let jsonOrderList = try? decoder.decode([Order].self, from: orderListData) {
                                        if let jsonFunds = try? decoder.decode(Double.self, from: fundsData) {
                                            if let jsonUserStocksOrder = try? decoder.decode([String].self, from: userStocksOrderData) {
                                                if let jsonDeliveryMargin = try? decoder.decode([Date: Double].self, from: deliveryMarginData) {
                                                    DispatchQueue.main.async {
                                                        self.portfolio = jsonPortfolio
                                                        self.orderList = jsonOrderList
                                                        self.funds = jsonFunds
                                                        self.userStocksOrder = jsonUserStocksOrder
                                                        self.deliveryMargin = jsonDeliveryMargin
                                                    }
                                                }
                                            }
                                        }
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
        //        self.portfolio = []
        //        self.orderList = []
        //        self.funds = 1_00_000.0
        //        self.deliveryMargin = [:]
        //        self.userStocksOrder = ["RELIANCE", "HDFCBANK", "INFY", "HDFC", "ICICIBANK", "TCS", "KOTAKBANK", "HINDUNILVR", "AXISBANK", "ITC", "LT"]
        //        saveData()
    }
}


extension Double {
    func withCommas(withRupeeSymbol: Bool) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_IN")
        if withRupeeSymbol {
            numberFormatter.numberStyle = .currency
        } else {
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
        }
        numberFormatter.groupingSize = 3
        numberFormatter.secondaryGroupingSize = 2
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}


extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
