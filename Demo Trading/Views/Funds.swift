//
//  FundsView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

let deliveryMarginExplanation = "According to SEBI guidelines, 80% of the money received from selling holdings will be instanly available for new trades, and the rest 20% will be available the next day. This feature was implemented into the app to make it seem more realistic. 🙃"

let totalNetWorthExplanation = "This is the sum of your funds and the value of stocks you own. It shows the total amount that you have gained or lost compared to your starting funds, which was ₹1,00,000."

import SwiftUI

struct FundsView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(height: 1)
                    
                    VStack {
                        Text("\(data.funds.withCommas(withRupeeSymbol: true))")
                        //                        Text("21,356.85")
                            .font(.title)
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
                        data.showMessage(message: deliveryMarginExplanation, error: false)
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
                .padding(.top, 1)
                
                HStack {
                    Button(action: {
                        data.showMessage(message: totalNetWorthExplanation, error: false)
                    }) {
                        HStack {
                            Text("Total Net Worth:")
                                .foregroundColor(Color("Black White"))
                            Image(systemName: "info.circle.fill")
                            
                        }
                    }
                    Spacer()
                    Text("\(getTotalNetWorth().withCommas(withRupeeSymbol: true))\n\(changeInNetWorth().withCommas(withRupeeSymbol: false)) %")
                        .foregroundColor(changeInNetWorth() >= 0 ? .green : .red)
                        .multilineTextAlignment(.trailing)
                    
                }
                .padding(.horizontal)
                .padding(.top, 1)
                
                Spacer()
                Image("money")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                Spacer()
                Spacer()
            }
            .padding(.top)
            .navigationTitle("Funds")
        }
    }
    
    func changeInNetWorth() -> Double {
        return ((getTotalNetWorth() -  1_00_000) / 1_00_000 * 100)
    }
    
    func getTotalNetWorth() -> Double {
        //        return 107856.40
        let holdingsInfo = data.getPorfolioInfo(portfolio: data.holdings)
        let positionsInfo = data.getPorfolioInfo(portfolio: data.positions)
        var totalValue = 0.0
        
        totalValue += holdingsInfo["currentValue"]!
        totalValue += positionsInfo["currentValue"]!
        totalValue += getDeliveryMargin()
        totalValue += data.funds
        
        return totalValue
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
