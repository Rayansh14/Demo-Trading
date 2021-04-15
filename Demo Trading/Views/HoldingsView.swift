//
//  HoldingsView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct HoldingsView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        VStack {
            if data.holdings.count == 0 {
                Text("No Holdings 😭")
            } else {
                ScrollView {
                    ForEach(data.holdings) {holding in
                        Text(holding.stockSymbol)
                        Text(String(holding.numberOfShares))
                        Text(String(holding.priceBought))
                    }
                }
            }
        }
    }
}

struct HoldingsView_Previews: PreviewProvider {
    static var previews: some View {
        HoldingsView()
    }
}
