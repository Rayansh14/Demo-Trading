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
                Text("Starting balance: ₹ 1,00,000")
                Text("Available funds :\(data.funds.withCommas(withRupeeSymbol: true))")
                Text("Delivery Margin :\(getDeliveryMargin().withCommas(withRupeeSymbol: true))")
                Text("Total Net Worth :\(getTotalNetWorth().withCommas(withRupeeSymbol: true))")
            }
            .navigationTitle("Funds")
            .navigationBarItems(trailing: NavigationLink(destination: about()) {
                Image(systemName: "info.circle.fill")
            })
        }
    }
    
    
    func getTotalNetWorth() -> Double {
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
        var sum = 0.0
        for amt in data.deliveryMargin.values {
            sum += amt
        }
        return sum
    }
}


struct about: View {
    var body: some View {
        Text("only nifty 500 companies, updates less often (about twice a minute), one lakh in fantasy amount provided")
            .padding()
    }
}

struct FundsView_Previews: PreviewProvider {
    static var previews: some View {
        FundsView()
    }
}
