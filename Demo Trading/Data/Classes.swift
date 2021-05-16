//
//  StockQuote.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 13/04/21.
//

import Foundation


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


var testOrder: Order {
    let order = Order()
    order.stockSymbol = "RELIANCE"
    order.numberOfShares = 10
    order.sharePrice = 2002.30
    order.type = .buy
    return order
}


class StockOwned: ObservableObject, Identifiable, Codable {
    @Published var id = UUID().uuidString
    @Published var stockSymbol = ""
    @Published var numberOfShares = 0
    @Published var avgPriceBought: Double = 0.0
    @Published var lastPrice: Double = 0.0
    @Published var dayChange: Double = 0.0
    @Published var timeBought = Date()
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case stockSymbol
        case numberOfShares
        case avgPriceBought
        case lastPrice
        case dayChange
        case timeBought
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(stockSymbol, forKey: .stockSymbol)
        try container.encode(numberOfShares, forKey: .numberOfShares)
        try container.encode(avgPriceBought, forKey: .avgPriceBought)
        try container.encode(dayChange, forKey: .dayChange)
        try container.encode(timeBought, forKey: .timeBought)
        try container.encode(lastPrice, forKey: .lastPrice)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        stockSymbol = try values.decode(String.self, forKey: .stockSymbol)
        numberOfShares = try values.decode(Int.self, forKey: .numberOfShares)
        avgPriceBought = try values.decode(Double.self, forKey: .avgPriceBought)
        dayChange = try values.decode(Double.self, forKey: .dayChange)
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
    stockOwned.avgPriceBought = 2002.30
    stockOwned.dayChange = 12.20
    stockOwned.lastPrice = 2004.75
    return stockOwned
}
