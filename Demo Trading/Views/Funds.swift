//
//  FundsView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 14/04/21.
//

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
                .padding(.top, 1)
                
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
                    // definitely some performace improvements by not calling functions 4 times
                    Text("\(getTotalNetWorth().withCommas(withRupeeSymbol: true))\n\(changeInNetWorth() > 0 ? "+" : "" )\(changeInNetWorth().withCommas(withRupeeSymbol: false)) %")
                        .foregroundColor(changeInNetWorth() >= 0 ? .green : .red)
                        .multilineTextAlignment(.trailing)
                    
                }
                .padding(.horizontal)
                .padding(.top, 1)
                
                HStack {
                    Button(action: {data.showMessage(message: overperformaceExplanation, error: false, duration: 8)}) {
                        HStack {
                            Text("Performance relative to nifty: ")
                                .foregroundColor(Color("Black White"))
                            Image(systemName: "info.circle.fill")
                            
                        }
                    }
                    Spacer()
                    Text("\(getOverperformance() > 0 ? "+" : "")\(getOverperformance().withCommas(withRupeeSymbol: false))%")
                        .foregroundColor(getOverperformance() >= 0 ? .green : .red)
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
    
    func getOverperformance() -> Double {
        let nifty = data.getStockQuote(stockSymbol: "NIFTY 50").lastPrice
        let niftyReturn = nifty/data.niftyWhenStarted*100
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
