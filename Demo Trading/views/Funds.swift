//
//  FundsView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

import SwiftUI

struct FundsView: View {
    
    @ObservedObject var data = DataController.shared
    @State private var refresh = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 1)
                    
                    VStack {
                        Text("\(data.funds.withCommas(withRupeeSymbol: true))")
                        //                        Text("21,356.85")
                            .font(.custom("Poppins-Regular", size: 28))
                        Text("Available Funds")
                    }
                    .frame(minWidth: 200)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 10).stroke())
                    
                    Rectangle()
                        .frame(height: 1)
                }
                
                
                HStack {
                    Text("Starting balance:")
                    Spacer()
                    Text("₹ 1,00,000")
                }
                .padding(.horizontal)
                .padding(.top, 15)
                
                HStack {
                    Button(action: {
                        data.showMessage(message: deliveryMarginExplanation, error: false, duration: 10)
                    }) {
                        HStack {
                            Text("Delivery Margin: ")
                                .foregroundColor(Color("Black White"))
                            Image(systemName: "info.circle.fill")
                        }
                    }
                    Spacer()
                    //                    Text("3,845.15")
                    Text("\(getDeliveryMargin().withCommas(withRupeeSymbol: true))")
                }
                .padding(.horizontal)
                
                HStack {
                    Button(action: {
                        data.showMessage(message: totalNetWorthExplanation, error: false, duration: 9)
                    }) {
                        HStack {
                            Text("Total Net Worth:")
                                .foregroundColor(Color("Black White"))
                            Image(systemName: "info.circle.fill")
                            
                        }
                    }
                    Spacer()
                    let changeInNetWorth = changeInNetWorth()
                    Text("\(getTotalNetWorth().withCommas(withRupeeSymbol: true))\n\(changeInNetWorth > 0 ? "+" : "" )\(changeInNetWorth.withCommas()) %")
                        .foregroundColor(changeInNetWorth >= 0 ? .green : .red)
                        .multilineTextAlignment(.trailing)
                    
                }
                .padding(.horizontal)
                
                HStack {
                    Button(action: {data.showMessage(message: getOPExplanation(), error: false, duration: 8)}) {
                        HStack {
                            Text("Performance relative to Nifty: ")
                                .foregroundColor(Color("Black White"))
                            Image(systemName: "info.circle.fill")
                            
                        }
                    }
                    Spacer()
                    Text("\(getOverperformance() > 0 ? "+" : "")\(getOverperformance().withCommas())%")
                        .foregroundColor(getOverperformance() >= 0 ? .green : .red)
                }
                .padding(.horizontal)
                
                Spacer()
                Image("money")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                Spacer()
                Spacer()
            }
            .font(.custom("Poppins-Regular", size: 15.5))
            .padding(.top)
            .navigationTitle("Funds")
            .navigationBarItems(trailing: Button(action: {refresh.toggle()}) {
                Image(systemName: "gobackward")
            })
        }
    }
    
    func changeInNetWorth() -> Double {
        return (getTotalNetWorth() -  1_00_000) / 1_00_000 * 100
    }
    
    func getTotalNetWorth() -> Double {
        //        return 107856.40
        let holdingsInfo = data.portfolioInfo[1]
        let positionsInfo = data.portfolioInfo[0]
        var totalValue = 0.0
        
        totalValue += holdingsInfo["currentValue"]!
        totalValue += positionsInfo["currentValue"]!
        totalValue += getDeliveryMargin()
        totalValue += data.funds
        
        for order in data.pendingLimitOrders {
            if order.transactionType == .buy {
                totalValue += order.sharePrice * Double(order.numberOfShares)
            }
        }
        
        return totalValue
    }
    
    func getOverperformance() -> Double {
        if data.niftyWhenStarted == 0 {
            return 0
        }
        
        let nifty = data.getStockQuote(stockSymbol: "NIFTY 50").displayPrice
        let niftyReturn = (nifty-data.niftyWhenStarted) / data.niftyWhenStarted * 100
        return changeInNetWorth() - niftyReturn
    }
    
    func getDeliveryMargin() -> Double {
        for dm in data.deliveryMargin {
            if dm.key < Date().dateAt(.endOfDay) {
                data.funds += dm.value
                data.deliveryMargin.removeValue(forKey: dm.key)
            }
        }
        var sum = 0.0
        for amt in data.deliveryMargin.values {
            sum += amt
        }
        return sum
    }
}



struct FundsView_Previews: PreviewProvider {
    static var previews: some View {
        FundsView()
    }
}
