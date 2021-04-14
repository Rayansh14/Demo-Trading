//
//  DataController.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/04/21.
//

import Foundation
import SwiftUI

class DataController: ObservableObject {
    
    static var shared = DataController()
    @Published var stockQuotes: [StockQuote] = []
    let stockQuotesOrder = ["RELIANCE", "HDFCBANK", "INFY", "HDFC", "ICICIBANK", "TCS", "KOTAKBANK", "HINDUNILVR", "AXISBANK", "ITC", "LT", "SBIN", "BAJFINANCE", "BHARTIARTL", "ASIANPAINT", "HCLTECH", "MARUTI", "M&M", "ULTRACEMCO", "SUNPHARMA", "WIPRO", "INDUSINDBK", "TITAN", "BAJAJFINSV", "NESTLEIND", "TATAMOTORS", "TECHM", "HDFCLIFE", "POWERGRID", "DRREDDY", "TATASTEEL", "NTPC", "BAJAJ-AUTO", "ADANIPORTS", "HINDALCO", "GRASIM", "DIVISLAB", "HEROMOTOCO", "ONGC", "CIPLA", "BRITANNIA", "JSWSTEEL", "BPCL", "EICHERMOT", "SHREECEM", "SBILIFE", "COALINDIA", "UPL", "IOC", "TATACONSUM"]
    
    
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
}
