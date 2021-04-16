//
//  StockQuote.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 13/04/21.
//

import Foundation


class StockQuote: ObservableObject, Identifiable, Codable {
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
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case lastPrice
        case change
        case pChange
        case dayHigh
        case dayLow
        case previousClose
        case open
        case totalTradedVolume
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(symbol, forKey: CodingKeys.symbol)
        try container.encode(lastPrice, forKey: CodingKeys.lastPrice)
        try container.encode(change, forKey: CodingKeys.change)
        try container.encode(pChange, forKey: CodingKeys.pChange)
        try container.encode(dayHigh, forKey: CodingKeys.dayHigh)
        try container.encode(dayLow, forKey: CodingKeys.dayLow)
        try container.encode(previousClose, forKey: CodingKeys.previousClose)
        try container.encode(open, forKey: CodingKeys.open)
        try container.encode(totalTradedVolume, forKey: CodingKeys.totalTradedVolume)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        symbol = try values.decode(String.self, forKey: .symbol)
        lastPrice = try values.decode(Double.self, forKey: .lastPrice)
        change = try values.decode(Double.self, forKey: .change)
        pChange = try values.decode(Double.self, forKey: .pChange)
        dayHigh = try values.decode(Double.self, forKey: .dayHigh)
        dayLow = try values.decode(Double.self, forKey: .dayLow)
        previousClose = try values.decode(Double.self, forKey: .previousClose)
        open = try values.decode(Double.self, forKey: .open)
        totalTradedVolume = try values.decode(Int.self, forKey: .totalTradedVolume)
    }
    
    init() {
    }
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
}


class StockOwned: ObservableObject, Identifiable, Codable {
    @Published var id = UUID().uuidString
    @Published var stockSymbol = ""
    @Published var numberOfShares = 0
    @Published var priceBought: Double = 0.0
    @Published var timeBought = Date()
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case stockSymbol
        case numberOfShares
        case priceBought
        case timeBought
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(stockSymbol, forKey: .stockSymbol)
        try container.encode(numberOfShares, forKey: .numberOfShares)
        try container.encode(priceBought, forKey: .priceBought)
        try container.encode(timeBought, forKey: .timeBought)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        stockSymbol = try values.decode(String.self, forKey: .stockSymbol)
        numberOfShares = try values.decode(Int.self, forKey: .numberOfShares)
        priceBought = try values.decode(Double.self, forKey: .priceBought)
        timeBought = try values.decode(Date.self, forKey: .timeBought)
    }
    
    init() {
    }
}
