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
    
    @Published var stockQuotes: [StockQuote] = []
    @Published var userStocksOrder: [String] = []
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
    
    @Published var deliveryMargin: [Date: Double] = [:]
    
    @Published var showMessage = false
    @Published var message = ""
    @Published var isError = true
    @Published var pendingLimitOrders: [Order] = []
    
    
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
                            stockQuote.lastPrice = Double(jsonQuote["price"]!)!
                            stockQuote.updateTime = getDateFromAPITime(stringTime: jsonQuote["time"]!)
                            stockQuote.symbol = jsonQuote["symbol"]!.uppercased()
                            stockQuote.change = Double(jsonQuote["day_change"]!)!
                            stockQuote.previousClose = stockQuote.lastPrice - stockQuote.change
                            stockQuote.pChange = stockQuote.change / stockQuote.previousClose * 100
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
                                stockQuote.lastPrice = jsonStockQuote["lastPrice"] as! Double
                                stockQuote.change = jsonStockQuote["change"] as! Double
                                stockQuote.pChange = jsonStockQuote["pChange"] as! Double
                                stockQuote.dayHigh = jsonStockQuote["dayHigh"] as! Double
                                stockQuote.dayLow = jsonStockQuote["dayLow"] as! Double
                                stockQuote.previousClose = jsonStockQuote["previousClose"] as! Double
                                stockQuote.open = jsonStockQuote["previousClose"] as! Double
                                stockQuote.totalTradedVolume = jsonStockQuote["totalTradedVolume"] as! Int
                                
                                // 07-Dec-2021 16:00:00
                                
                                stockQuote.updateTime = getDateFromAPITime(stringTime: jsonStockQuote["lastUpdateTime"] as! String)
                                
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
                                self.checkLimitOrders()
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
            if order.transactionType == .buy && quote.lastPrice <= order.sharePrice && quote.lastPrice > 0 {
                order.time = quote.updateTime
                self.executeBuyOrder(order: order)
                self.removeLimitOrderFromPending(order: order)
            } else if order.transactionType == .sell && quote.lastPrice >= order.sharePrice {
                order.time = quote.updateTime
                self.executeSellOrder(order: order)
                self.removeLimitOrderFromPending(order: order)
            }
        }
    }
    
    
    func getStockOwned(stockSymbol: String) -> StockOwned? {
        if let stockOwned = portfolio.first(where: { loopingStockOwned in
            loopingStockOwned.stockSymbol == stockSymbol
        }) {
            return stockOwned
        }
        return nil
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
            stock.dayProfitLoss = Double(stock.numberOfShares) * stock.dayChange
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
            portfolioInfo["dayProfitLoss"]! += stock.dayProfitLoss
        }
        portfolioInfo["profitLoss"]! = portfolioInfo["currentValue"]! - portfolioInfo["buyValue"]!
        portfolioInfo["profitLossPercent"]! = portfolioInfo["profitLoss"]!/portfolioInfo["buyValue"]! * 100
        return portfolioInfo
    }
    
    
    func checkLimitOrders() {
        print("check limit order function was called")
        print(pendingLimitOrders.count)
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
                                let time = getDateFromAPITime(stringTime: quote["time"] as! String)
                                let price = (quote["price"] as! NSString).doubleValue
                                
                                
                                if time > order.time && time.compare(.isSameDay(order.time)) {
                                    if order.transactionType == .buy && price <= order.sharePrice {
                                        order.time = time
                                        self.executeBuyOrder(order: order)
                                        self.removeLimitOrderFromPending(order: order)
                                        break
                                    } else if order.transactionType == .sell && price >= order.sharePrice {
                                        order.time = time
                                        self.executeSellOrder(order: order)
                                        self.removeLimitOrderFromPending(order: order)
                                        break
                                    }
                                }
                                // if the quote was of the day after the order was placed, cancel the order, return the funds and break the loop
                                if !time.compare(.isSameDay(order.time)) && time > order.time { // if the quote time was on a different day and it was after the order was placed
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
        
        if niftyWhenStarted == 0 {
            niftyWhenStarted = getStockQuote(stockSymbol: "NIFTY 50").lastPrice
        }
        saveData()
    }
    
    
    func executeSellOrder(order: Order) {
        orderList.append(order)
        let stockOwned = getStockOwned(stockSymbol: order.stockSymbol)!
        
        if stockOwned.numberOfShares == order.numberOfShares {
            if let index = portfolio.firstIndex(where: {loopingStockOwned -> Bool in
                return loopingStockOwned.id == stockOwned.id
            }) {
                portfolio.remove(at: index)
            }
        } else {
            stockOwned.numberOfShares -= order.numberOfShares
        }
        
        if checkIfInHoldings(stockSymbol: stockOwned.stockSymbol) {
            funds += (Double(order.numberOfShares) * order.sharePrice) * 0.8
            let date = Date() + 5.hours + 30.minutes + 1.days
            self.deliveryMargin[date] = Double(order.numberOfShares) * order.sharePrice * 0.2
            
        } else {
            funds += (Double(order.numberOfShares) * order.sharePrice)
        }
        saveData()
        
        showMessage(message: "S😎LD \(order.stockSymbol.uppercased())! You got \((Double(order.numberOfShares) * order.sharePrice).withCommas(withRupeeSymbol: true)) from that sale! You now have \(funds.withCommas(withRupeeSymbol: true)).", error: false)
    }
    
    
    func processLimitOrder(order: Order) {
        if order.transactionType == .buy {
            funds -= (order.sharePrice * Double(order.numberOfShares))
            if order.sharePrice < getStockQuote(stockSymbol: order.stockSymbol).lastPrice {
                pendingLimitOrders.append(order)
                showMessage(message: "Placed an order to buy \(order.numberOfShares) share of \(order.stockSymbol.uppercased()) @ \(order.sharePrice.withCommas(withRupeeSymbol: true)).", error: false)
            } else {
                order.sharePrice = getStockQuote(stockSymbol: order.stockSymbol).lastPrice
                executeBuyOrder(order: order)
            }
        } else {
            if order.sharePrice > getStockQuote(stockSymbol: order.stockSymbol).lastPrice {
                pendingLimitOrders.append(order)
                showMessage(message: "Placed an order to sell \(order.numberOfShares) share of \(order.stockSymbol.uppercased()) @ \(order.sharePrice.withCommas(withRupeeSymbol: true)).", error: false)
            } else {
                order.sharePrice = getStockQuote(stockSymbol: order.stockSymbol).lastPrice
                executeSellOrder(order: order)
            }
        }
    }
    
    
    func processOrder(order: Order, quoteUpdateTime: Date) {
        if getMarketStatus() { // if the market is open rn
            if (quoteUpdateTime + 4.minutes) > Date.now { // if the quote was updated recently
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
                    if let stockOwned = getStockOwned(stockSymbol: order.stockSymbol) {
                        if stockOwned.numberOfShares >= order.numberOfShares {
                            if order.orderType == .market {
                                executeSellOrder(order: order)
                            }
                        } else {
                            showMessage(message: "Seriously??? You're trying to sell more shares than you own?! 😡")
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
                                    if let pendingLimitOrdersData = try? encoder.encode(self.pendingLimitOrders) {
                                        UserDefaults.standard.setValue(niftyData, forKey: "niftyWhenStarted")
                                        UserDefaults.standard.setValue(portfolioData, forKey: "portfolio")
                                        UserDefaults.standard.setValue(orderListData, forKey: "orderList")
                                        UserDefaults.standard.setValue(fundsData, forKey: "funds")
                                        UserDefaults.standard.setValue(userStocksOrderData, forKey: "userStocksOrder")
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
    
    
    func loadData() {
        DispatchQueue.global().async {
            if let portfolioData = UserDefaults.standard.data(forKey: "portfolio") {
                if let orderListData = UserDefaults.standard.data(forKey: "orderList") {
                    if let fundsData = UserDefaults.standard.data(forKey: "funds") {
                        if let userStocksOrderData = UserDefaults.standard.data(forKey: "userStocksOrder") {
                            if let deliveryMarginData = UserDefaults.standard.data(forKey: "deliveryMargin") {
                                if let niftyData = UserDefaults.standard.data(forKey: "niftyWhenStarted") {
                                    if let pendingLimitOrdersData = UserDefaults.standard.data(forKey: "pendingLimitOrders") {
                                        let decoder = JSONDecoder()
                                        if let jsonPortfolio = try? decoder.decode([StockOwned].self, from: portfolioData) {
                                            if let jsonOrderList = try? decoder.decode([Order].self, from: orderListData) {
                                                if let jsonFunds = try? decoder.decode(Double.self, from: fundsData) {
                                                    if let jsonUserStocksOrder = try? decoder.decode([String].self, from: userStocksOrderData) {
                                                        if let jsonDeliveryMargin = try? decoder.decode([Date: Double].self, from: deliveryMarginData) {
                                                            if let jsonNifty = try? decoder.decode(Double.self, from: niftyData) {
                                                                if let jsonPendingLimitOrders = try? decoder.decode([Order].self, from: pendingLimitOrdersData) {
                                                                    DispatchQueue.main.async {
                                                                        self.niftyWhenStarted = jsonNifty
                                                                        self.portfolio = jsonPortfolio
                                                                        self.orderList = jsonOrderList
                                                                        self.funds = jsonFunds
                                                                        self.userStocksOrder = jsonUserStocksOrder
                                                                        self.deliveryMargin = jsonDeliveryMargin
                                                                        self.pendingLimitOrders = jsonPendingLimitOrders
                                                                        print("\(self.pendingLimitOrders.count) pending orders")
                                                                        print("\(jsonPendingLimitOrders.count) pending orders")
                                                                        self.checkLimitOrders()
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

func getDateFromAPITime(stringTime: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MMM-y HH:mm:ss"
    return formatter.date(from: stringTime)!
}
