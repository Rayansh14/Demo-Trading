//
//  OrdersView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

enum OrdersType: String {
    case executed, pending
}

struct OrdersView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        NavigationView {
            TabView {
                OrderListView(ordersType: .executed)
                OrderListView(ordersType: .pending)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
        }
    }
}


struct OrderListView: View {
    
    @ObservedObject var data = DataController.shared
    var ordersType: OrdersType
    @State private var isTodayExpanded = true
    @State private var isEarlierExpanded = false
    
    var body: some View {
        ZStack {
            Image("signature")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top)
                .opacity((data.orderList.count < 2 && data.earlierOrders.count < 1) ? 1 : 0.2)
            VStack {
                ScrollView {
                    if ordersType == .executed {
                        DisclosureGroup(isExpanded: $isTodayExpanded, content: {
                            VStack {
                                if data.todayOrders.count == 0 {
                                    Text("You have placed no orders today. Buy or sell a stock by going to your watchlist and selecting the stock that you want to trade.")
                                        .font(.body)
                                        .foregroundColor(Color("Black White"))
                                } else {
                                    ForEach(data.todayOrders) { order in
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color("Divider Gray"))
                                        OrderTileView(order: order)
                                    }
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("Divider Gray"))
                                }
                            }
                        }, label: {Text("Today").foregroundColor(Color("Black White"))})
                            .font(.title2)
                            .padding()
                        
                        if data.earlierOrders.count != 0 {
                            DisclosureGroup(isExpanded: $isEarlierExpanded, content: {
                                VStack {
                                    ForEach(data.earlierOrders) { order in
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color("Divider Gray"))
                                        OrderTileView(order: order)
                                    }
                                    
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color("Divider Gray"))
                                }
                            }, label: {Text("Earlier").foregroundColor(Color("Black White"))})
                                .font(.title2)
                                .padding()
                        }
                    } else {
                        VStack {
                        if data.pendingLimitOrders.count == 0 {
                            Text("You have placed no orders today. Buy or sell a stock by going to your watchlist and selecting the stock that you want to trade.")
                                .font(.body)
                                .foregroundColor(Color("Black White"))
                                .padding(.horizontal)
                        } else {
                            ForEach(data.pendingLimitOrders) { order in
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("Divider Gray"))
                                OrderTileView(order: order)
                            }
                            .padding(.horizontal)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color("Divider Gray"))
                        }
                    }
                        .padding(.top)
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("\(ordersType.rawValue.capitalized) Orders")
    }
}


struct OrderTileView: View {
    
    var order: Order
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(order.transactionType.rawValue.capitalized)
                    .font(.system(size: 15))
                    .foregroundColor(order.transactionType.rawValue == "buy" ? .green : .red)
                Text(order.stockSymbol)
                    .foregroundColor(Color("Black White"))
                    .font(.system(size: 21))
                Text(order.orderType.rawValue.capitalized)
                    .font(.system(size: 15))
                    .foregroundColor(Color("Gray"))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                Text("Qty: \(order.numberOfShares)")
                    .font(.system(size: 15))
                    .foregroundColor(Color("Gray"))
                Text("\(order.sharePrice.withCommas())")
                    .foregroundColor(Color("Black White"))
                    .font(.system(size: 20))
                Text("\(order.dateAsString())")
                    .font(.system(size: 15))
                    .foregroundColor(Color("Gray"))
            }
        }
        .padding(.top, 1)
    }
}


struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OrdersView()
            //                .preferredColorScheme(.dark)
            OrderTileView(order: testOrder)
        }
    }
}
