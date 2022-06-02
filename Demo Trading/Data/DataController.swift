//
//  DataController.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import SwiftUI
import SwiftDate


let deliveryMarginExplanation = "According to SEBI (the market regulator) guidelines, 80% of the money received from selling holdings will be instanly available for new trades, and the rest 20% will be available the next day."

let totalNetWorthExplanation = "This is the sum of your funds and the value of stocks you own. It shows the total amount that you have gained or lost compared to your starting funds, which was ₹1,00,000."

let overperformaceExplanation = "This is how much better/worse you are doing than the Nifty 50 index. The time period is since you placed your first order."

let heading2 = Font.custom("Poppins-Regular", size: 20)
let heading1 = Font.custom("Poppins-Regular", size: 23)

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
    @Published var tabsShowing = true //this is so that the watchlist tabs disappear when user is searching for stock to add in a watchlist
    
    @Published var stockQuotes: [StockQuote] = []
    @Published var watchlist: [[String]] = [[], [], []]
    //    @Published var userStocksOrder: [String] = ["NIFTY 50", "RELIANCE", "HDFCBANK", "INFY", "HDFC", "ICICIBANK", "TCS", "KOTAKBANK", "HINDUNILVR", "AXISBANK", "ITC", "LT"]
    //    "RELIANCE", "HDFCBANK", "INFY", "HDFC", "ICICIBANK", "TCS", "KOTAKBANK", "HINDUNILVR", "AXISBANK", "ITC", "LT"
    
    @Published var portfolio: [StockOwned] = []
    var positions: [StockOwned] {
        return portfolio.filter { $0.timeBought > Date().dateAt(.startOfDay) }
    }
    var holdings: [StockOwned] {
        return portfolio.filter { $0.timeBought < Date().dateAt(.startOfDay) }
    }
    //    var holdings = [test3, test4, test5]
    
    @Published var orderList: [Order] = []
    var todayOrders: [Order] {
        return orderList.filter { $0.time > Date().dateAt(.startOfDay) }.sorted { $0.time > $1.time }
    }
    var earlierOrders: [Order] {
        return orderList.filter { $0.time < Date().dateAt(.startOfDay) }.sorted { $0.time > $1.time }
    }
    
    @Published var funds: Double = 1_00_000.0
    @Published var isFirstTime = true
    
    @Published var deliveryMargin: [Date: Double] = [:]
    
    @Published var showMessage = false
    @Published var message = ""
    @Published var isError = true
    @Published var pendingLimitOrders: [Order] = []
    @Published var portfolioInfo: [[String: Double]] = [
        [
            "id": 0, // 0 is for positions, 1 is for holdings
            "investedValue" : 0,
            "currentValue" : 0,
            "profitLoss" : 0,
            "profitLossPercent" : 0,
            "dayProfitLoss" : 0
        ],
        [
            "id": 1, // 0 is for positions, 1 is for holdings
            "investedValue" : 0,
            "currentValue" : 0,
            "profitLoss" : 0,
            "profitLossPercent" : 0,
            "dayProfitLoss" : 0
        ]
    ]
    
    
    func getMarketStatus() -> Bool {
        return true
        
        let calendar = Calendar.current
        let now = Date()
        let nineFifteenToday = calendar.date(bySettingHour: 9, minute: 14, second: 59, of: now)!
        let threeThirtyToday = calendar.date(bySettingHour: 15, minute: 30, second: 00, of: now)!
        
        if now.compare(.isWeekday) && now > nineFifteenToday && now < threeThirtyToday {
            return true
        }
        return false
    }
    
    
    func getStocksDataFromPython() {
        print("getting data from python api")
        if let url = URL(string: "https://fantasytrading.pythonanywhere.com/latest") {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let webdata = data {
                    if let json = try? JSONSerialization.jsonObject(with: webdata, options: []) as? [[String:String]] {
                        print("python api \(json.count)")
                        for jsonQuote in json {
                            let stockQuote = StockQuote()
                            stockQuote.actualPrice = Double(jsonQuote["price"]!)!
                            stockQuote.displayPrice = stockQuote.actualPrice
                            stockQuote.updateTime = getDateFromAPITime(stringTime: jsonQuote["time"]!)
                            stockQuote.symbol = jsonQuote["symbol"]!.uppercased()
                            stockQuote.previousClose = stockQuote.displayPrice - Double(jsonQuote["day_change"]!)!
                            DispatchQueue.main.async {
                                if self.stockQuotes.firstIndex(where: {$0.symbol == stockQuote.symbol}) == nil { // this is so that when api returns incomplete stock quotes, it keeps the earlier quotes of the stocks whose quote it has not received
                                    self.stockQuotes.append(stockQuote)
                                }
                            }
                        }
                    }
                }
            }.resume()
        }
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
                                stockQuote.actualPrice = jsonStockQuote["lastPrice"] as! Double
                                stockQuote.displayPrice = stockQuote.actualPrice
//                                stockQuote.change = jsonStockQuote["change"] as! Double
//                                stockQuote.pChange = jsonStockQuote["pChange"] as! Double
                                stockQuote.dayHigh = jsonStockQuote["dayHigh"] as! Double
                                stockQuote.dayLow = jsonStockQuote["dayLow"] as! Double
                                stockQuote.previousClose = jsonStockQuote["previousClose"] as! Double
                                stockQuote.open = jsonStockQuote["open"] as! Double
                                stockQuote.totalTradedVolume = jsonStockQuote["totalTradedVolume"] as! Int
                                
                                // 07-Dec-2021 16:00:00
                                
                                stockQuote.updateTime = getDateFromAPITime(stringTime: jsonStockQuote["lastUpdateTime"] as! String)
                                
                                DispatchQueue.main.async {
                                    if let index = self.stockQuotes.firstIndex(where: {$0.symbol == stockQuote.symbol}) { // this is so that when api returns incomplete stock quotes, it keeps the earlier quotes of the stocks whose new quote it has not received
                                        self.stockQuotes.remove(at: index)
                                    }
                                    
                                    self.stockQuotes.append(stockQuote)
                                }
                            }
                            
                            print(count)
                            if count == 0 {
                                print("getting data again......")
                                if self.stockQuotes.count < 50 {
                                    self.getStocksDataFromPython()
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                        self.getStocksData()
                                        print("got new data!\n")
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                //                                self.checkLimitOrdersFromApi()
                                self.compareLimitOrderToLatestQuote()
                            }
                        }
                    }
                }.resume()
            }
        } else {
            showMessage(message: "Not connected to internet.")
        }
        for order in pendingLimitOrders {
            let quote = getStockQuote(stockSymbol: order.stockSymbol)
            if order.transactionType == .buy && quote.displayPrice <= order.sharePrice && quote.displayPrice > 0 {
                order.time = quote.updateTime
                self.executeBuyOrder(order: order)
                self.removeLimitOrderFromPending(order: order)
            } else if order.transactionType == .sell && quote.displayPrice >= order.sharePrice {
                order.time = quote.updateTime
                self.executeSellOrder(order: order)
                self.removeLimitOrderFromPending(order: order)
            }
        }
    }
    
    
    func compareLimitOrderToLatestQuote() {
        for order in pendingLimitOrders {
            let stockQuote = getStockQuote(stockSymbol: order.stockSymbol)
            
            if stockQuote.updateTime > order.time && stockQuote.updateTime.compare(.isSameDay(order.time)) {
                if order.transactionType == .buy && stockQuote.displayPrice <= order.sharePrice {
                    order.time = stockQuote.updateTime
                    self.executeBuyOrder(order: order)
                    self.removeLimitOrderFromPending(order: order)
                } else if order.transactionType == .sell && stockQuote.displayPrice >= order.sharePrice {
                    order.time = stockQuote.updateTime
                    self.executeSellOrder(order: order)
                    self.removeLimitOrderFromPending(order: order)
                }
            }
        }
    }
    
    
    func checkLimitOrdersFromApi() {
        //        print("check limit order function was called")
        //        print(pendingLimitOrders.count)
        for order in pendingLimitOrders {
            if let url = URL(string: "https://fantasytrading.pythonanywhere.com/intraday?symbol=\(order.stockSymbol)") {
                let request = URLRequest(url: url)
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    print("fantasytrading.pythonanywhere.com was called")
                    if let webData = data {
                        if let jsonData = try? JSONSerialization.jsonObject(with: webData, options: []) as? [[String: Any]] {
                            /*
                             1. get list of all prices after order was placed on the day the order was placed
                             2. if transaction type is buy,
                             a. if min price <= price at which user wants to buy, then execute the order
                             b. if not, then cancel the order
                             3. if transaction type is sell,
                             a. if max price >= price at which user wants to sell, then execute the order
                             b. if not, then cancel the order
                             */
                            
                            for quote in jsonData {
                                var stockQuote: StockQuote {
                                    let q = StockQuote()
                                    q.updateTime = getDateFromAPITime(stringTime: quote["time"] as! String)
                                    q.displayPrice = (quote["price"] as! NSString).doubleValue
                                    return q
                                }
                                
                                
                                if stockQuote.updateTime > order.time && stockQuote.updateTime.compare(.isSameDay(order.time)) {
                                    if order.transactionType == .buy && stockQuote.displayPrice <= order.sharePrice {
                                        order.time = stockQuote.updateTime
                                        self.executeBuyOrder(order: order)
                                        self.removeLimitOrderFromPending(order: order)
                                        break
                                    } else if order.transactionType == .sell && stockQuote.displayPrice >= order.sharePrice {
                                        order.time = stockQuote.updateTime
                                        self.executeSellOrder(order: order)
                                        self.removeLimitOrderFromPending(order: order)
                                        break
                                    }
                                }
                                // if the quote was of the day after the order was placed, cancel the order, return the funds and break the loop
                                if !stockQuote.updateTime.compare(.isSameDay(order.time)) && stockQuote.updateTime > order.time { // if the quote time was on a different day and it was after the order was placed
                                    if order.transactionType == .buy {
                                        self.funds += order.sharePrice * Double(order.numberOfShares)
                                    }
                                    self.removeLimitOrderFromPending(order: order)
                                    break
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    
    func randomIncrement() {
        if getMarketStatus() {
            print("randomIncrement function called")
            for quote in stockQuotes {
                let maxIncrement = max(0.05, quote.actualPrice * 0.0005)
                let i = Double.random(in: -maxIncrement...maxIncrement)
                let roundedi = round(i*20)/20
//                print("\(quote.symbol) increment is \(roundedi)")
                if abs((quote.displayPrice + roundedi) - quote.actualPrice) <= max(0.05, quote.actualPrice * 0.0015) {
                    quote.displayPrice = quote.displayPrice + roundedi
                }
//                print("\(quote.symbol) display price is \(quote.displayPrice)")
//                quote.change = quote.displayPrice - quote.previousClose
//                quote.pChange = quote.change / quote.previousClose * 100
                quote.dayHigh = max(quote.dayHigh, quote.displayPrice)
                quote.dayLow = min(quote.dayLow, quote.displayPrice)
            }
            stockQuotes.append(StockQuote())
            if let index = stockQuotes.firstIndex(where: {$0.symbol == ""}) {
                stockQuotes.remove(at: index)
            }
            updatePorfolioInfo()
        }
    }
    
    
    func getStockOwned(stockSymbol: String, portfolioType: PortfolioType) -> StockOwned? {
        if let stockOwned = (portfolioType == .positions ? positions : holdings).first(where: { loopingStockOwned in
            loopingStockOwned.stockSymbol == stockSymbol
        }) {
            return stockOwned
        }
        return nil
    }
    
    
    func updateHoldingsPositions() {
        for stock in holdings { // this is to remove duplicates from the holdings array
            let filtered = holdings.filter({ $0.stockSymbol == stock.stockSymbol }) // create new array 'filtered' which contains all instances with a particular stock name.
            if filtered.count > 1 { // if there are any duplicates,
                let stocko = filtered[0] // new constant 'stocko', which has the first duplicate
                
                for stock in filtered[1...] { // loop over all other duplicates
                    stocko.avgPriceBought = ((stock.avgPriceBought * Double(stock.numberOfShares)) + (stocko.avgPriceBought * Double(stocko.numberOfShares)))/Double(stocko.numberOfShares + stock.numberOfShares) // adjusts avg price
                    stocko.numberOfShares += stock.numberOfShares
                }
                
                self.portfolio = portfolio.filter({ stockOwned in // removes all StockOwned instances that are in filtered
                    !filtered.contains(where: {$0.id == stockOwned.id}) // if the timeBought of loopingStockOwned is the same as any StockOwned instance in filtered array, then do not include that loopingStockOwned in the updated portfolio array
                })
                self.portfolio.append(stocko)
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
        if holdings.first(where: { loopingStock -> Bool in
            loopingStock.stockSymbol == stockSymbol
        }) != nil {
            return true
        }
        return false
    }
    
    
    func checkIfInPositions(stockSymbol: String) -> Bool {
        if positions.first(where: { loopingStock -> Bool in
            loopingStock.stockSymbol == stockSymbol
        }) != nil {
            return true
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
        self.message = "\(message)\(watchlist.count == 0 ? "\n Tap to dismiss" : "")"
        self.isError = error
        showMessage = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration)) {
            self.showMessage = false
        }
    }
    
    
    func resetPortfolioInfo() {
        portfolioInfo = []
        for x in 0...1 {
            portfolioInfo.append([
                "id": Double(x),
                "investedValue" : 0,
                "currentValue" : 0,
                "profitLoss" : 0,
                "profitLossPercent" : 0,
                "dayProfitLoss" : 0
            ])
        }
    }
    
    
    func updatePorfolioInfo() {
        resetPortfolioInfo()
        for x in 0...1 {
            print(x)
            for stock in x == 0 ? positions : holdings {
                let quote = getStockQuote(stockSymbol: stock.stockSymbol)
                portfolioInfo[x]["investedValue"]! += (stock.avgPriceBought * Double(stock.numberOfShares))
                portfolioInfo[x]["currentValue"]! += (quote.displayPrice * Double(stock.numberOfShares))
                print(portfolioInfo[x]["currentValue"]!)
                portfolioInfo[x]["dayProfitLoss"]! += quote.change * Double(stock.numberOfShares)
            }
            portfolioInfo[x]["profitLoss"]! = portfolioInfo[x]["currentValue"]! - portfolioInfo[x]["investedValue"]!
            if portfolioInfo[x]["investedValue"]! > 0 {
                portfolioInfo[x]["profitLossPercent"]! = portfolioInfo[x]["profitLoss"]!/portfolioInfo[x]["investedValue"]! * 100
            }
        }
        
        portfolioInfo.append([:])
        portfolioInfo.remove(at: 2)
        
//        return portfolioInfo
    }
    
    
    func removeLimitOrderFromPending(order: Order) {
        if let index = self.pendingLimitOrders.firstIndex(where: { loopingOrder -> Bool in
            loopingOrder.id == order.id
        }) {
            self.pendingLimitOrders.remove(at: index)
        }
    }
    
    
    func executeBuyOrder(order: Order) {
        
        orderList.append(order)
        if checkIfInPositions(stockSymbol: order.stockSymbol) {
            if let stock = positions.first(where: { $0.stockSymbol == order.stockSymbol }) {
                
                stock.avgPriceBought = ((stock.avgPriceBought * Double(stock.numberOfShares)) + (order.sharePrice * Double(order.numberOfShares)))/Double(stock.numberOfShares + order.numberOfShares)
                stock.numberOfShares += order.numberOfShares // this works because StockOwned is a class and classes are reference types, so updating this updates the class in the portfolio array as well.
                
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
        
        if niftyWhenStarted == 0 {
            niftyWhenStarted = getStockQuote(stockSymbol: "NIFTY 50").displayPrice
        }
        saveData()
    }
    
    
    func executeSellOrder(order: Order) {
        var holdingsSold = 0
        
        orderList.append(order)
        let positionsStockOwned = getStockOwned(stockSymbol: order.stockSymbol, portfolioType: .positions) ?? StockOwned()
        let holdingsStockOwned = getStockOwned(stockSymbol: order.stockSymbol, portfolioType: .holdings) ?? StockOwned()
        
        if positionsStockOwned.numberOfShares >= order.numberOfShares {
            positionsStockOwned.numberOfShares -= order.numberOfShares
        } else if positionsStockOwned.numberOfShares == 0 {
            holdingsStockOwned.numberOfShares -= order.numberOfShares
            holdingsSold += order.numberOfShares
        } else {
            let numSharesLeft = order.numberOfShares - positionsStockOwned.numberOfShares
            positionsStockOwned.numberOfShares = 0
            holdingsStockOwned.numberOfShares -= numSharesLeft
            holdingsSold = numSharesLeft
        }
//        
//        if positionsStockOwned.numberOfShares == order.numberOfShares {
//            if let index = portfolio.firstIndex(where: {loopingStockOwned -> Bool in
//                return loopingStockOwned.id == positionsStockOwned.id
//            }) {
//                portfolio.remove(at: index)
//            }
//        } else if order.numberOfShares < positionsStockOwned.numberOfShares {
//            positionsStockOwned.numberOfShares -= order.numberOfShares
//        }
        
        for _ in 1...portfolio.count {
            if let index = portfolio.firstIndex(where: { loopingStockOwned in
                loopingStockOwned.numberOfShares == 0 || loopingStockOwned.stockSymbol == ""
            }) {
                portfolio.remove(at: index)
            } else {
                break
            }
        }
        
        if holdingsSold > 0 {
            funds += (Double(holdingsSold) * order.sharePrice) * 0.8
            let date = Date() + 5.hours + 30.minutes + 1.days
            self.deliveryMargin[date] = Double(holdingsSold) * order.sharePrice * 0.2
            
        } else {
            funds += (Double(order.numberOfShares) * order.sharePrice)
        }
        saveData()
        
        showMessage(message: "S😎LD \(order.stockSymbol.uppercased())! You got \((Double(order.numberOfShares) * order.sharePrice).withCommas(withRupeeSymbol: true)) from that sale! You now have \(funds.withCommas(withRupeeSymbol: true)).", error: false)
    }
    
    
    func processLimitOrder(order: Order) {
        if order.transactionType == .buy {
            funds -= (order.sharePrice * Double(order.numberOfShares))
            if order.sharePrice < getStockQuote(stockSymbol: order.stockSymbol).displayPrice {
                pendingLimitOrders.append(order)
                showMessage(message: "Placed an order to buy \(order.numberOfShares) share of \(order.stockSymbol.uppercased()) @ \(order.sharePrice.withCommas(withRupeeSymbol: true)).", error: false)
            } else {
                order.sharePrice = getStockQuote(stockSymbol: order.stockSymbol).displayPrice
                executeBuyOrder(order: order)
            }
        } else {
            if order.sharePrice > getStockQuote(stockSymbol: order.stockSymbol).displayPrice {
                pendingLimitOrders.append(order)
                showMessage(message: "Placed an order to sell \(order.numberOfShares) share of \(order.stockSymbol.uppercased()) @ \(order.sharePrice.withCommas(withRupeeSymbol: true)).", error: false)
            } else {
                order.sharePrice = getStockQuote(stockSymbol: order.stockSymbol).displayPrice
                executeSellOrder(order: order)
            }
        }
    }
    
    
    func processOrder(order: Order, quoteUpdateTime: Date) {
        if getMarketStatus() { // if the market is open rn
            if true {//(quoteUpdateTime + 4.minutes) > Date.now { // if the quote was updated recently
                if order.transactionType == .buy { // if the transaction type is buy
                    if funds >= (order.sharePrice * Double(order.numberOfShares)) { // if the user has enough funds
                        if order.orderType == .market { // if the user has placed a market order
                            
                            funds -= (order.sharePrice * Double(order.numberOfShares))
                            executeBuyOrder(order: order)
                            
                        } else {
                            processLimitOrder(order: order)
                        }
                    } else {
                        showMessage(message: "Not enough funds! Sell some stocks or reduce the number of shares.")
                    }
                } else {
                    let numberOfShares = getTotalSharesOwned(stockSymbol: order.stockSymbol)
                        if numberOfShares >= order.numberOfShares {
                            if order.orderType == .market {
                                executeSellOrder(order: order)
                            } else {
                                processLimitOrder(order: order)
                            }
                        } else {
                            showMessage(message: "Seriously??? You're trying to sell more shares than you own?! 😡")
                        }
                    if numberOfShares == 0 {
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
    
    
    func getTotalSharesOwned(stockSymbol: String) -> Int {
        return ((getStockOwned(stockSymbol: stockSymbol, portfolioType: .holdings) ?? StockOwned()).numberOfShares + (getStockOwned(stockSymbol: stockSymbol, portfolioType: .positions) ?? StockOwned()).numberOfShares)
    }
    
    
    func saveData() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            if let niftyData = try? encoder.encode(self.niftyWhenStarted) {
                if let portfolioData = try? encoder.encode(self.portfolio) {
                    if let orderListData = try? encoder.encode(self.orderList) {
                        if let fundsData = try? encoder.encode(self.funds) {
                            if let userStocksOrderData = try? encoder.encode(self.watchlist) {
                                if let deliveryMarginData = try? encoder.encode(self.deliveryMargin) {
                                    if let pendingLimitOrdersData = try? encoder.encode(self.pendingLimitOrders) {
                                        if let isFirstTimeData = try? encoder.encode(self.isFirstTime) {
                                            UserDefaults.standard.setValue(isFirstTimeData, forKey: "isFirstTime")
                                        UserDefaults.standard.setValue(niftyData, forKey: "niftyWhenStarted")
                                        UserDefaults.standard.setValue(portfolioData, forKey: "portfolio")
                                        UserDefaults.standard.setValue(orderListData, forKey: "orderList")
                                        UserDefaults.standard.setValue(fundsData, forKey: "funds")
                                        UserDefaults.standard.setValue(userStocksOrderData, forKey: "watchlist")
                                        UserDefaults.standard.setValue(deliveryMarginData, forKey: "deliveryMargin")
                                        UserDefaults.standard.setValue(pendingLimitOrdersData, forKey: "pendingLimitOrders")
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
    
    
    func loadData() {
        DispatchQueue.global().async {
            if let isFirstTimeData = UserDefaults.standard.data(forKey: "isFirstTime") {
            if let portfolioData = UserDefaults.standard.data(forKey: "portfolio") {
                if let orderListData = UserDefaults.standard.data(forKey: "orderList") {
                    if let fundsData = UserDefaults.standard.data(forKey: "funds") {
                        if let watchlistData = UserDefaults.standard.data(forKey: "watchlist") {
                            if let deliveryMarginData = UserDefaults.standard.data(forKey: "deliveryMargin") {
                                if let niftyData = UserDefaults.standard.data(forKey: "niftyWhenStarted") {
                                    if let pendingLimitOrdersData = UserDefaults.standard.data(forKey: "pendingLimitOrders") {
                                        let decoder = JSONDecoder()
                                        if let isFirstTime = try? decoder.decode(Bool.self, from: isFirstTimeData) {
                                        if let jsonPortfolio = try? decoder.decode([StockOwned].self, from: portfolioData) {
                                            if let jsonOrderList = try? decoder.decode([Order].self, from: orderListData) {
                                                if let jsonFunds = try? decoder.decode(Double.self, from: fundsData) {
                                                    if let jsonWatchlist = try? decoder.decode([[String]].self, from: watchlistData) {
                                                        if let jsonDeliveryMargin = try? decoder.decode([Date: Double].self, from: deliveryMarginData) {
                                                            if let jsonNifty = try? decoder.decode(Double.self, from: niftyData) {
                                                                if let jsonPendingLimitOrders = try? decoder.decode([Order].self, from: pendingLimitOrdersData) {
                                                                    DispatchQueue.main.async {
                                                                        self.isFirstTime = isFirstTime
                                                                        self.niftyWhenStarted = jsonNifty
                                                                        self.portfolio = jsonPortfolio
                                                                        self.orderList = jsonOrderList
                                                                        self.funds = jsonFunds
                                                                        self.watchlist = jsonWatchlist
                                                                        self.deliveryMargin = jsonDeliveryMargin
                                                                        self.pendingLimitOrders = jsonPendingLimitOrders
                                                                        print("\(self.pendingLimitOrders.count) pending orders")
                                                                        print("\(jsonPendingLimitOrders.count) pending orders")
                                                                        self.checkLimitOrdersFromApi()
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
    func withCommas(withRupeeSymbol: Bool = false) -> String {
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
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        return clipShape(RoundedShape(radius: radius, corners: corners))
    }
}

struct RoundedShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [corners], cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension Array {
    func getElementOrDefault(index: Int, defaultVal: Element) -> Element {
        if index + 1 > self.count {
            return defaultVal
        }
        return self[index]
    }
}


extension TabView {
    func applyGuideChars() -> some View {
        self
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationBarTitleDisplayMode(.inline)
    }
}


extension View {
    func guidePadding() -> some View {
        self
            .padding(.horizontal)
            .padding(.bottom, 50)
    }
}


func getDateFromAPITime(stringTime: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MMM-y HH:mm:ss"
    return formatter.date(from: stringTime)!
}


struct FlatLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
