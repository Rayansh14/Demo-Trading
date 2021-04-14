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
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case lastPrice
        case change
        case pChange
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(symbol, forKey: CodingKeys.symbol)
        try container.encode(lastPrice, forKey: CodingKeys.lastPrice)
        try container.encode(change, forKey: CodingKeys.change)
        try container.encode(pChange, forKey: CodingKeys.pChange)
    }
    
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        symbol = try values.decode(String.self, forKey: .symbol)
        lastPrice = try values.decode(Double.self, forKey: .lastPrice)
        change = try values.decode(Double.self, forKey: .change)
        pChange = try values.decode(Double.self, forKey: .pChange)
    }
    
    init() {
    }
}
