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
        }
    }
    
    
    func getTotalNetWorth() -> Double {
        let holdingsInfo = data.getPorfolioInfo(portfolio: data.holdings)
        let positionsInfo = data.getPorfolioInfo(portfolio: data.positions)
        var totalValue = 0.0
        
        totalValue += holdingsInfo["currentValue"]!
        totalValue += positionsInfo["currentValue"]!
        totalValue += data.funds
        
        return totalValue
    }
    
    func getDeliveryMargin() -> Double {
        if let amount = data.deliveryMargin["amount"] as? Double {
            return amount
        }
        return 0.0
    }
}

struct FundsView_Previews: PreviewProvider {
    static var previews: some View {
        FundsView()
    }
}
