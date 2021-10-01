//
//  ErrorTileView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 17/04/21.
//

import SwiftUI

struct ErrorTileView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        HStack {
            Spacer()
            Text(data.message)
                .foregroundColor(data.isError ? .red : .green)
                .padding(10)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding()
        .shadow(radius: 5)
    }
}

struct ErrorTileView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorTileView()
    }
}
