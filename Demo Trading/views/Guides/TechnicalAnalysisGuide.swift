//
//  TechnicalAnalysisGuide.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 19/02/22.
//

import SwiftUI

struct TechnicalAnalysisGuide: View {
    var body: some View {
        TabView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Candlesticks")
                        .font(.custom("Poppins-Regular", size: 23))
                    
                    Text("The Japanese art of candlestick trading has been around for nearly 400 years. Japanese rice traders successfully used these signal formations to amass huge fortunes. Since then, the signals have been refined, tested and utilized in variety of markets. Wherever an instrument can be traded in an open market by traders, candlestick signals can be used to profit in such markets.\nThey visually show a trader the sentiments of the other traders in that particular stock or market.")
                        .multilineTextAlignment(.leading)
                        .font(.custom("Poppins-Light", size: 18))
                }
                .padding(.bottom, 30)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationTitle("Technical Analysis")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
    }
}

struct TechnicalAnalysisGuide_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        TechnicalAnalysisGuide()
        }
    }
}
