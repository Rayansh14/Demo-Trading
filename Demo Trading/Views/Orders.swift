//
//  OrdersView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct OrdersView: View {
    
    @ObservedObject var data = DataController.shared
    @State private var isTodayExpanded = true
    @State private var isEarlierExpanded = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("signature")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top)
                    .opacity((data.orderList.count < 2 && data.earlierOrders.count < 1) ? 1 : 0.2)
                VStack {
                    ScrollView {
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
                            .foregroundColor(.black)
                            .padding()
                            .cornerRadius(15)
                        
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
                                .foregroundColor(.black)
                                .padding()
                                .cornerRadius(15)
                        }
                        Spacer()
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
            VStack(alignment: .leading) {
                Text(order.type.rawValue.capitalized)
                    .font(.body)
                    .foregroundColor(order.type.rawValue == "buy" ? .green : .red)
                Text(order.stockSymbol)
                    .foregroundColor(Color("Black White"))
                    .font(.system(size: 22))
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Qty: \(order.numberOfShares)")
                    .font(.body)
                    .foregroundColor(Color("Gray"))
                Text("\(order.sharePrice.withCommas(withRupeeSymbol: false))")
                    .foregroundColor(Color("Black White"))
                    .font(.system(size: 21))
                Text("\(order.dateAsString())")
                    .font(.body)
                    .foregroundColor(Color("Gray"))
            }
        }
        .padding(.top, 1)
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
            .preferredColorScheme(.dark)
    }
}
