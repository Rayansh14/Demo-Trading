//
//  DataController.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import Foundation
import SwiftDate

class DataController: ObservableObject {
    
    static var shared = DataController()
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
    
    @Published var funds: Double = 100000.0
    
    
    func getStocksData() {
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
                                print(String(lastPrice))
                            }
                            if let change = jsonStockQuote["change"] as? Double {
                                stockQuote.change = change
                                print(String(change))
                            }
                            if let pChange = jsonStockQuote["pChange"] as? Double {
                                stockQuote.pChange = pChange
                                print(String(pChange))
                            }
                            if let dayHigh = jsonStockQuote["dayHigh"] as? Double {
                                stockQuote.dayHigh = dayHigh
                                print(String(dayHigh))
                            }
                            if let dayLow = jsonStockQuote["dayLow"] as? Double {
                                stockQuote.dayLow = dayLow
                                print(String(dayLow))
                            }
                            if let previousClose = jsonStockQuote["previousClose"] as? Double {
                                stockQuote.previousClose = previousClose
                                print(String(previousClose))
                            }
                            if let open = jsonStockQuote["open"] as? Double {
                                stockQuote.open = open
                                print(String(open))
                            }
                            if let totalTradedVolume = jsonStockQuote["totalTradedVolume"] as? Int {
                                stockQuote.totalTradedVolume = totalTradedVolume
                                print(String(totalTradedVolume))
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
    }
    
    
    func processOrder(order: Order) {
        if order.type == .buy {
            if self.funds >= (order.sharePrice * Double(order.numberOfShares)) {
                funds -= (order.sharePrice * Double(order.numberOfShares))
                let stockOwned = StockOwned()
                stockOwned.numberOfShares = order.numberOfShares
                stockOwned.priceBought = order.sharePrice
                stockOwned.stockSymbol = order.stockSymbol
                stockOwned.timeBought = order.time
                self.orderList.append(order)
                self.portfolio.append(stockOwned)
                print(String(funds))
            } else {
                print("Not enough funds! Sell some holdings or reduce the number of shares.")
            }
        }
    }
}
