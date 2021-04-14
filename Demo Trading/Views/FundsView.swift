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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FundsView_Previews: PreviewProvider {
    static var previews: some View {
        FundsView()
    }
}
