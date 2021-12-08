//
//  DataController.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI
import SwiftDate


let deliveryMarginExplanation = "According to SEBI (the market regulator) guidelines, 80% of the money received from selling holdings will be instanly available for new trades, and the rest 20% will be available the next day. This feature was implemented into the app to make it more realistic. 🙃"

let totalNetWorthExplanation = "This is the sum of your funds and the value of stocks you own. It shows the total amount that you have gained or lost compared to your starting funds, which was ₹1,00,000."

let overperformaceExplanation = "This is how much better/worse you are doing than the nifty 50 index. The time period is since you placed your first order."

func getOPExplanation() -> String {
    if DataController.shared.niftyWhenStarted > 0 {
        return overperformaceExplanation + "\nWhen you started, Nifty 50 was at \(DataController.shared.niftyWhenStarted)"
    }
    return overperformaceExplanation
}


class DataController: ObservableObject {
    
    static var shared = DataController()
    @ObservedObject var monitor = NetworkMonitor()
    @Published var niftyWhenStarted = 0.0
    
    @Published var showTab = true
    
    @Published var stockQuotes: [StockQuote] = []
    @Published var userStocksOrder: [String] = []
    //    @Published var userStocksOrder: [String] = ["NIFTY 50", "RELIANCE", "HDFCBANK", "INFY", "HDFC", "ICICIBANK", "TCS", "KOTAKBANK", "HINDUNILVR", "AXISBANK", "ITC", "LT"]
    //    "RELIANCE", "HDFCBANK", "INFY", "HDFC", "ICICIBANK", "TCS", "KOTAKBANK", "HINDUNILVR", "AXISBANK", "ITC", "LT"
    
    @Published var portfolio: [StockOwned] = []
    var positions: [StockOwned] {
        return portfolio.filter { $0.timeBought > Date().dateAt(.startOfDay) }
    }
    //    var positions = [testStockOwned, test1, test2]
    
    //    var holdings = [test4, test3, test5]
    var holdings: [StockOwned] {
        return portfolio.filter { $0.timeBought < Date().dateAt(.startOfDay) }
    }
    
    @Published var orderList: [Order] = []
    //    var todayOrders = [testOrder, testOrder2, testOrder3]
    var todayOrders: [Order] {
        return orderList.filter { $0.time > Date().dateAt(.startOfDay) }.sorted { $0.time > $1.time } // > means later than
    }
    //    var earlierOrders = [testOrder4]
    var earlierOrders: [Order] {
        return orderList.filter { $0.time < Date().dateAt(.startOfDay) }.sorted { $0.time > $1.time }
    }
    
    @Published var funds: Double = 1_00_000.0
    
    @Published var deliveryMargin: [Date: Double] = [:]
    
    @Published var showMessage = false
    @Published var message = ""
    @Published var isError = true
    
    
    func getMarketStatus() -> Bool {
        //        return true
        
        let calendar = Calendar.current
        let now = Date()
        let nineFifteenToday = calendar.date(bySettingHour: 9, minute: 14, second: 59, of: now)!
        let threeThirtyToday = calendar.date(bySettingHour: 15, minute: 30, second: 00, of: now)!
        
        if now.compare(.isWeekday) && now > nineFifteenToday && now < threeThirtyToday {
            return true
        }
        return false
    }
    
    
    func getStocksData() {
        if monitor.isConnected {
            if let url = URL(string: "https://latest-stock-price.p.rapidapi.com/any") {
                var request = URLRequest(url: url)
                request.addValue("7fb21cb036msh42efbbec95f083fp193e7bjsn0fc5005cafa3", forHTTPHeaderField: "x-rapidapi-key")
                request.addValue("latest-stock-price.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
                //                request.addValue("true", forHTTPHeaderField: "useQueryString")
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let webData = data {
                        if let json = try? JSONSerialization.jsonObject(with: webData, options: []) as? [[String:Any]] {
                            
                            var count = 0
                            
                            for jsonStockQuote in json {
                                count += 1
                                let stockQuote = StockQuote()
                                
                                stockQuote.symbol = jsonStockQuote["symbol"] as! String
                                stockQuote.lastPrice = jsonStockQuote["lastPrice"] as! Double
                                stockQuote.change = jsonStockQuote["change"] as! Double
                                stockQuote.pChange = jsonStockQuote["pChange"] as! Double
                                stockQuote.dayHigh = jsonStockQuote["dayHigh"] as! Double
                                stockQuote.dayLow = jsonStockQuote["dayLow"] as! Double
                                stockQuote.previousClose = jsonStockQuote["previousClose"] as! Double
                                stockQuote.open = jsonStockQuote["previousClose"] as! Double
                                stockQuote.totalTradedVolume = jsonStockQuote["totalTradedVolume"] as! Int
                                
                                // 07-Dec-2021 16:00:00
                                
                                let stringDate = jsonStockQuote["lastUpdateTime"] as! String
                                let stringTime = stringDate.split(separator: " ")[1]
                                let stringTimeIndividual = stringTime.split(separator: ":")
                                
                                let stringDay = stringDate.split(separator: " ")[0]
                                let stringDayIndividual = stringDay.split(separator: "-")
                                
                                
                                
                                let calendar = Calendar.current
                                
                                var components = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: Date())
                                components.month = getMonthNumber(for: stringDayIndividual[1])
                                components.day = Int(stringDayIndividual[0])
                                components.hour = Int(stringTimeIndividual[0])!
                                components.minute = Int(stringTimeIndividual[1])!
                                components.second = Int(stringTimeIndividual[2])!
                                
                                stockQuote.updateTime = calendar.date(from: components)!
                                
                                //                                stockQuote.updateTime = jsonStockQuote["lastUpdateTime"] as! Date
                                
                                //                                if let symbol = jsonStockQuote["symbol"] as? String {
                                //                                    stockQuote.symbol = symbol
                                //                                }
                                //                                if let lastPrice = jsonStockQuote["lastPrice"] as? Double {
                                //                                    stockQuote.lastPrice = lastPrice
                                //                                }
                                //                                if let change = jsonStockQuote["change"] as? Double {
                                //                                    stockQuote.change = change
                                //                                }
                                //                                if let pChange = jsonStockQuote["pChange"] as? Double {
                                //                                    stockQuote.pChange = pChange
                                //                                }
                                //                                if let dayHigh = jsonStockQuote["dayHigh"] as? Double {
                                //                                    stockQuote.dayHigh = dayHigh
                                //                                }
                                //                                if let dayLow = jsonStockQuote["dayLow"] as? Double {
                                //                                    stockQuote.dayLow = dayLow
                                //                                }
                                //                                if let previousClose = jsonStockQuote["previousClose"] as? Double {
                                //                                    stockQuote.previousClose = previousClose
                                //                                }
                                //                                if let open = jsonStockQuote["open"] as? Double {
                                //                                    stockQuote.open = open
                                //                                }
                                //                                if let totalTradedVolume = jsonStockQuote["totalTradedVolume"] as? Int {
                                //                                    stockQuote.totalTradedVolume = totalTradedVolume
                                //                                }
                                
                                DispatchQueue.main.async {
                                    if let index = self.stockQuotes.firstIndex(where: {$0.symbol == stockQuote.symbol}) { // this is so that when api returns incomplete stock quotes, it keeps the earlier quotes of the stocks whose quote it has not received
                                        self.stockQuotes.remove(at: index)
                                    }
                                    
                                    self.stockQuotes.append(stockQuote)
                                }
                            }
                            
                            
                            print(count)
                            if count == 0 {
                                print("getting data again......")
                                if self.stockQuotes.count == 0 {
                                    print("instantly")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        self.getStocksData()
                                        print("got new data!\n")
                                    }
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        self.getStocksData()
                                        print("got new data!\n")
                                        
                                    }
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
    
    
    func getStockOwned(stockSymbol: String) -> StockOwned? {
        if let index = portfolio.firstIndex(where: {loopingStockOwned -> Bool in
            return loopingStockOwned.stockSymbol.lowercased() == stockSymbol.lowercased()
        }) {
            return portfolio[index]
        }
        return nil
        //        return StockOwned()
    }
    
    
    func updateAllStockPricesInPortfolio() {
        for stock in holdings { // this is to remove duplicates from the holdings array
            let filtered = holdings.filter({ $0.stockSymbol == stock.stockSymbol }) // create new array 'filtered' which contains all instances with a particular stock name.
            if filtered.count > 1 { // if there are any duplicates,
                let stocko = filtered[0] // new constant 'stocko', which has the first duplicate
                
                for stock in filtered[1...] { // loop over all other duplicates
                    stocko.avgPriceBought = ((stock.avgPriceBought * Double(stock.numberOfShares)) + (stocko.avgPriceBought * Double(stocko.numberOfShares)))/Double(stocko.numberOfShares + stock.numberOfShares) // adjusts avg price
                    stocko.numberOfShares += stock.numberOfShares
                }
                
                
                self.portfolio = portfolio.filter({ stockOwned in // removes all StockOwned instances that are in filtered
                    !filtered.contains(where: {$0.timeBought == stockOwned.timeBought}) // if the timeBought of loopingStockOwned is the same as any StockOwned instance in filtered array, then do not include that loopingStockOwned in the updated portfolio array
                })
                self.portfolio.append(stocko)
            }
        }
        
        for stock in portfolio {
            let quote = getStockQuote(stockSymbol: stock.stockSymbol)
            stock.lastPrice = quote.lastPrice
            stock.dayChange = quote.change
            stock.dayPChange = quote.pChange
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
    
    
    func checkIfInPositions(stockSymbol: String) -> Bool {
        for stock in self.positions {
            if stock.stockSymbol == stockSymbol {
                return true
            }
        }
        return false
    }
    
    
    func getStockQuote(stockSymbol: String) -> StockQuote {
        if let quote = stockQuotes.first(where: { loopingQuote -> Bool in
            loopingQuote.symbol.lowercased() == stockSymbol.lowercased()
        }) {
            return quote
        }
        
        let newQuote = StockQuote()
        newQuote.symbol = stockSymbol
        return newQuote
    }
    
    
    func showMessage(message: String, error: Bool = true, duration: Int = 6) {
        self.message = "\(message)\(userStocksOrder.count == 0 ? "\n Tap to dismiss" : "")"
        self.isError = error
        showMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
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
    
    
    func processOrder(order: Order, quoteUpdateTime: Date) {
        if getMarketStatus() {
            if (quoteUpdateTime + 4.minutes) < Date.now {
                if order.type == .buy {
                    if funds >= (order.sharePrice * Double(order.numberOfShares)) {
                        orderList.append(order)
                        funds -= (order.sharePrice * Double(order.numberOfShares))
                        
                        if checkIfInPositions(stockSymbol: order.stockSymbol) {
                            if let stock = positions.first(where: { $0.stockSymbol == order.stockSymbol }) {
                                
                                stock.avgPriceBought = ((stock.avgPriceBought * Double(stock.numberOfShares)) + (order.sharePrice * Double(order.numberOfShares)))/Double(stock.numberOfShares + order.numberOfShares)
                                stock.numberOfShares += order.numberOfShares
                                
                            }
                        } else {
                            let stockOwned = StockOwned()
                            stockOwned.numberOfShares = order.numberOfShares
                            stockOwned.avgPriceBought = order.sharePrice
                            stockOwned.stockSymbol = order.stockSymbol
                            stockOwned.timeBought = order.time
                            portfolio.append(stockOwned)
                        }
                        
                        showMessage(message: "You bought \(order.numberOfShares) shares of \(order.stockSymbol) @ \(order.sharePrice.withCommas(withRupeeSymbol: true))! And you still have \(self.funds.withCommas(withRupeeSymbol: true)) left.", error: false)
                    } else {
                        showMessage(message: "Not enough funds! Sell some stocks or reduce the number of shares.")
                    }
                    
                    if niftyWhenStarted == 0 {
                        niftyWhenStarted = getStockQuote(stockSymbol: "NIFTY 50").lastPrice
                    }
                } else {
                    if checkIfOwned(stockSymbol: order.stockSymbol) {
                        if let stock = portfolio.first(where: {loopingStock -> Bool in
                            loopingStock.stockSymbol == order.stockSymbol
                        }) {
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
                                
                                showMessage(message: "S😎LD! You got \((Double(order.numberOfShares) * order.sharePrice).withCommas(withRupeeSymbol: true)) from that sale! You now have \(funds.withCommas(withRupeeSymbol: true)).", error: false)
                            } else {
                                showMessage(message: "Seriously??? You're trying to sell more shares than you own?! 😡")
                            }
                        }
                    } else {
                        showMessage(message: "You can't sell what you don't own! 😡")
                    }
                }
                saveData()
            } else {
                showMessage(message: "The stock price hasn't been refreshed in a while. Try manually refreshing it from your watchlist tab")
            }
        } else {
            showMessage(message: "The stock market is not open right now. Please try again when it is open.")
        }
    }
    
    
    func saveData() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            if let niftyData = try? encoder.encode(self.niftyWhenStarted) {
                if let portfolioData = try? encoder.encode(self.portfolio) {
                    if let orderListData = try? encoder.encode(self.orderList) {
                        if let fundsData = try? encoder.encode(self.funds) {
                            if let userStocksOrderData = try? encoder.encode(self.userStocksOrder) {
                                if let deliveryMarginData = try? encoder.encode(self.deliveryMargin) {
                                    UserDefaults.standard.setValue(niftyData, forKey: "niftyWhenStarted")
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
    }
    
    
    func loadData() {
        DispatchQueue.global().async {
            if let portfolioData = UserDefaults.standard.data(forKey: "portfolio") {
                if let orderListData = UserDefaults.standard.data(forKey: "orderList") {
                    if let fundsData = UserDefaults.standard.data(forKey: "funds") {
                        if let userStocksOrderData = UserDefaults.standard.data(forKey: "userStocksOrder") {
                            if let deliveryMarginData = UserDefaults.standard.data(forKey: "deliveryMargin") {
                                if let niftyData = UserDefaults.standard.data(forKey: "niftyWhenStarted") {
                                    let decoder = JSONDecoder()
                                    if let jsonPortfolio = try? decoder.decode([StockOwned].self, from: portfolioData) {
                                        if let jsonOrderList = try? decoder.decode([Order].self, from: orderListData) {
                                            if let jsonFunds = try? decoder.decode(Double.self, from: fundsData) {
                                                if let jsonUserStocksOrder = try? decoder.decode([String].self, from: userStocksOrderData) {
                                                    if let jsonDeliveryMargin = try? decoder.decode([Date: Double].self, from: deliveryMarginData) {
                                                        if let jsonNifty = try? decoder.decode(Double.self, from: niftyData) {
                                                            DispatchQueue.main.async {
                                                                self.niftyWhenStarted = jsonNifty
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
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

func getMonthNumber(for monthString: String.SubSequence) -> Int {
    let months = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
    return months.firstIndex(of: String(monthString).lowercased())! + 1
}
