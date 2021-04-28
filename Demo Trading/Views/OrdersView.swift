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
        NavigationView {
            VStack {
                if data.orderList.count == 0 {
                    Text("No orders yet. Buy a stock by going to your watchlist and selecting a stock")
                } else {
                    ScrollView {
                        ForEach(data.orderList) { order in
                            Divider()
                            OrderTileView(order: order)
                        }
                        Divider()
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }
}


struct OrderTileView: View {
    
    var order: Order
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(order.type.rawValue.capitalized)
                        .font(.system(size: 17))
                    Spacer()
                }
                HStack {
                    Text(order.stockSymbol)
                        .font(.system(size: 20))
                    Spacer()
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack {
                HStack {
                Spacer()
                    Text(String(order.numberOfShares))
                        .font(.system(size: 15))
                }
//                Text(String(order.sharePrice))
            }
            .padding(.horizontal)
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Divider()
            OrderTileView(order: testOrder)
            Divider()
        }
    }
}
