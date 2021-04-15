//
//  OrdersView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct OrdersView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        VStack {
            if data.orderList.count == 0 {
                Text("No orders yet. Buy a stock by going to your watchlist and selecting a stock")
            } else {
                ScrollView {
                ForEach(data.orderList) { order in
                    Text(order.stockSymbol)
                    Text(String(order.numberOfShares))
                    Text(String(order.sharePrice))
                }
                }
            }
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
