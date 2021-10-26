//
//  StockQuote.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 13/04/21.
//

import SwiftUI
import SwiftDate


class StockQuote: ObservableObject, Identifiable {
    @Published var id = UUID().uuidString
    @Published var symbol = ""
    @Published var lastPrice = 0.0
    @Published var change = 0.0
    @Published var pChange = 0.0
    @Published var dayHigh = 0.0
    @Published var dayLow = 0.0
    @Published var previousClose = 0.0
    @Published var open = 0.0
    @Published var totalTradedVolume = 0
}

var testStockQuote: StockQuote {
    let stockQuote = StockQuote()
    stockQuote.id = "1"
    stockQuote.symbol = "RELIANCE"
    stockQuote.lastPrice = 1932.3
    stockQuote.change = 21.15
    stockQuote.pChange = 1.11
    stockQuote.dayHigh = 1940.6
    stockQuote.dayLow = 1917.85
    stockQuote.previousClose = 1911.15
    stockQuote.open = 1924
    stockQuote.totalTradedVolume = 8958261
    
    return stockQuote
}


enum OrderType: String, Codable {
    case buy, sell
}

class Order: ObservableObject, Identifiable, Codable {
    @Published var id = UUID().uuidString
    @Published var stockSymbol = ""
    @Published var numberOfShares: Int = 0
    @Published var sharePrice: Double = 0.0
    @Published var type = OrderType.buy
    @Published var time = Date()
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case stockSymbol
        case numberOfShares
        case sharePrice
        case type
        case time
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(stockSymbol, forKey: .stockSymbol)
        try container.encode(numberOfShares, forKey: .numberOfShares)
        try container.encode(sharePrice, forKey: .sharePrice)
        try container.encode(type, forKey: .type)
        try container.encode(time, forKey: .time)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        stockSymbol = try values.decode(String.self, forKey: .stockSymbol)
        numberOfShares = try values.decode(Int.self, forKey: .numberOfShares)
        sharePrice = try values.decode(Double.self, forKey: .sharePrice)
        type = try values.decode(OrderType.self, forKey: .type)
        time = try values.decode(Date.self, forKey: .time)
    }
    
    init() {
    }
    
    func dateAsString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, H:mm"
        let dateAsString = formatter.string(from: time)
        return dateAsString
    }
}


var testOrder2: Order {
    let order = Order()
    order.stockSymbol = "RELIANCE"
    order.numberOfShares = 10
    order.sharePrice = 2002.30
    order.type = .buy
    order.time = Date() - 2.hours
    return order
}

var testOrder: Order {
    let order = Order()
    order.stockSymbol = "INFY"
    order.numberOfShares = 17
    order.sharePrice = 1582.30
    order.type = .buy
    order.time = Date() - 1.hours - 23.minutes
    return order
}

var testOrder3: Order {
    let order = Order()
    order.stockSymbol = "IEX"
    order.numberOfShares = 27
    order.sharePrice = 682.30
    order.type = .sell
    order.time = Date() - 2.hours - 47.minutes
    return order
}

var testOrder4: Order {
    let order = Order()
    order.stockSymbol = "IEX"
    order.numberOfShares = 35
    order.sharePrice = 621.35
    order.type = .buy
    order.time = Date() - 2.days - 1.hours - 23.minutes
    return order
}


class StockOwned: ObservableObject, Identifiable, Codable {
    @Published var id = UUID().uuidString
    @Published var stockSymbol = ""
    @Published var numberOfShares = 0
    @Published var avgPriceBought: Double = 0.0
    @Published var lastPrice: Double = 0.0
    @Published var dayChange: Double = 0.0
    @Published var dayPChange: Double = 0.0
    @Published var timeBought = Date()
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case stockSymbol
        case numberOfShares
        case avgPriceBought
        case lastPrice
        case timeBought
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(stockSymbol, forKey: .stockSymbol)
        try container.encode(numberOfShares, forKey: .numberOfShares)
        try container.encode(avgPriceBought, forKey: .avgPriceBought)
        try container.encode(timeBought, forKey: .timeBought)
        try container.encode(lastPrice, forKey: .lastPrice)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        stockSymbol = try values.decode(String.self, forKey: .stockSymbol)
        numberOfShares = try values.decode(Int.self, forKey: .numberOfShares)
        avgPriceBought = try values.decode(Double.self, forKey: .avgPriceBought)
        timeBought = try values.decode(Date.self, forKey: .timeBought)
        lastPrice = try values.decode(Double.self, forKey: .lastPrice)
    }
    
    init() {
    }
}

var testStockOwned: StockOwned {
    let stockOwned = StockOwned()
    stockOwned.stockSymbol = "RELIANCE"
    stockOwned.numberOfShares = 10
    stockOwned.avgPriceBought = 1982.30
    stockOwned.dayChange = 12.20
    stockOwned.dayPChange = 0.79
    stockOwned.lastPrice = 2004.75
    return stockOwned
}

var test1: StockOwned {
    let stockOwned = StockOwned()
    stockOwned.stockSymbol = "HDFCBANK"
    stockOwned.numberOfShares = 18
    stockOwned.avgPriceBought = 1681.55
    stockOwned.dayChange = 17.30
    stockOwned.dayPChange = 1.04
    stockOwned.lastPrice = 1687.60
    return stockOwned
}

var test2: StockOwned {
    let stockOwned = StockOwned()
    stockOwned.stockSymbol = "TCS"
    stockOwned.numberOfShares = 6
    stockOwned.avgPriceBought = 3657.65
    stockOwned.dayChange = -12.7
    stockOwned.dayPChange = -0.35
    stockOwned.lastPrice = 3634.45
    return stockOwned
}

var test3: StockOwned {
    let stockOwned = StockOwned()
    stockOwned.stockSymbol = "IDEA"
    stockOwned.numberOfShares = 1750
    stockOwned.avgPriceBought = 11.77
    stockOwned.dayChange = 0.6
    stockOwned.dayPChange = 6
    stockOwned.lastPrice = 10.6
    return stockOwned
}

var test4: StockOwned {
    let stockOwned = StockOwned()
    stockOwned.stockSymbol = "BANKBARODA"
    stockOwned.numberOfShares = 250
    stockOwned.avgPriceBought = 81.01
    stockOwned.dayChange = 2.75
    stockOwned.dayPChange = 3.08
    stockOwned.lastPrice = 92.15
    return stockOwned
}

var test5: StockOwned {
    let stockOwned = StockOwned()
    stockOwned.stockSymbol = "LT"
    stockOwned.numberOfShares = 15
    stockOwned.avgPriceBought = 1532.72
    stockOwned.dayChange = -39.35
    stockOwned.dayPChange = -2.13
    stockOwned.lastPrice = 1807.5
    return stockOwned
}

