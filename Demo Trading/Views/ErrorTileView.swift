//
//  ErrorTileView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 17/04/21.
//

import SwiftUI

struct ErrorTileView: View {
    
    var error: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(error)
                .foregroundColor(.red)
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
        ErrorTileView(error: "err")
    }
}
