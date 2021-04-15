//
//  PositionsView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct PositionsView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        VStack {
            if data.positions.count == 0 {
                Text("No Holdings 😭")
            } else {
                ScrollView {
                    ForEach(data.positions) {position in
                        Text(position.stockSymbol)
                        Text(String(position.numberOfShares))
                        Text(String(position.priceBought))
                    }
                }
            }
        }
    }
}

struct PositionsView_Previews: PreviewProvider {
    static var previews: some View {
        PositionsView()
    }
}
