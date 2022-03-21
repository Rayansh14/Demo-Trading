//
//  MainView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 21/03/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: {Guides()}) {
                    Text("Guides")
                }
                
                NavigationLink(destination: {PortfolioTabView()}) {
                    Text("Fantasy Portfolio")
                }
            }
            .navigation
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
