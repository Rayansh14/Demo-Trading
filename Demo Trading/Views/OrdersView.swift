//
//  OrdersView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct OrdersView: View {
    
    @ObservedObject var data = DataController.shared
    @State var isTodayExpanded = true
    @State var isEarlierExpanded = false
    
    var body: some View {
        NavigationView {
            VStack {
                DisclosureGroup("Today", isExpanded: $isTodayExpanded) {
                    VStack {
                        if data.todayOrders.count == 0 {
                            Text("You have placed no orders today. Buy or sell a stock by going to your watchlist and selecting the stock that you want to trade.")
                                .font(.body)
                        } else {
                            ScrollView {
                                ForEach(data.todayOrders) { order in
                                    Divider()
                                    OrderTileView(order: order)
                                }
                                Divider()
                            }
                        }
                    }
                }
                .font(.title2)
                .foregroundColor(.black)
                .padding()
//                .background(Color(#colorLiteral(red: 0.9499999881, green: 0.9499999881, blue: 0.9499999881, alpha: 1)))
                .cornerRadius(15)
                
                if data.earlierOrders.count != 0 {
                    DisclosureGroup("Earlier", isExpanded: $isEarlierExpanded) {
                        VStack {
                            ScrollView {
                                ForEach(data.earlierOrders) { order in
                                    Divider()
                                    OrderTileView(order: order)
                                }
                                Divider()
                            }
                        }
                    }
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
//                    .background(Color(#colorLiteral(red: 0.9499999881, green: 0.9499999881, blue: 0.9499999881, alpha: 1)))
                    .cornerRadius(15)
                }
                Spacer()
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
                        .font(.body)
                        .foregroundColor(order.type.rawValue == "buy" ? .green : .red)
                    Spacer()
                }
                HStack {
                    Text(order.stockSymbol)
                        .font(.system(size: 23))
                    Spacer()
                }
            }
            
            Spacer()
            
            VStack {
                HStack {
                    Spacer()
                    Text("Qty: \(order.numberOfShares)")
                        .font(.body)
                        .foregroundColor(Color(#colorLiteral(red: 0.2002688944, green: 0.2002688944, blue: 0.2002688944, alpha: 1)))
                }
                HStack {
                    Spacer()
                    Text("\(String(format: "%.2f", order.sharePrice))")
                        .font(.system(size: 22))
                }
                HStack {
                    Spacer()
                    Text("\(order.dateAsString())")
                        .font(.body)
                        .foregroundColor(Color(#colorLiteral(red: 0.2002688944, green: 0.2002688944, blue: 0.2002688944, alpha: 1)))
                }
                
            }
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
