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
                Text(String(format: "%.2f", data.funds))
            }
            .navigationTitle("Funds")
        }
    }
}

struct FundsView_Previews: PreviewProvider {
    static var previews: some View {
        FundsView()
    }
}
