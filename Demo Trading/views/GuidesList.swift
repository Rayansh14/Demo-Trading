//
//  Guides.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/02/22.
//

import SwiftUI

struct Guides: View {
    
    private var gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns) {
                
                NavigationLink(destination: BasicsGuide()) {
                    GuideTitleView(imageName: "stock-market-animation", title: "Stock Market Basics")
                }
                
                NavigationLink(destination: TechnicalAnalysisGuide()) {
                    GuideTitleView(imageName: "candlesticks", title: "Technical Analysis")
                }
                
                NavigationLink(destination: FundamentalAnalysisGuide()) {
                    GuideTitleView(imageName: "fundamental-analysis-animation", title: "Fundamental Analysis")
                }
            }
            .padding(15)
        }
        .navigationTitle("Guides")
    }
}


struct GuideTitleView: View {
    
    var imageName: String
    var title: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 110, height: 110)
                .padding(.horizontal, 5)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("Gray"))
            
            Text(title)
                .font(.custom("Poppins-Light", size: 18))
                .foregroundColor(Color("Black White"))
                .multilineTextAlignment(.center)
        }
        .frame(width: 125)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("White Black"))
                .shadow(color: .gray, radius: 5)
        )
        .padding(8)
    }
}


struct Guide_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                Guides()
//                    .preferredColorScheme(.dark)
            }
            //            NavigationView {
            //                BasicsGuide()
            //            }
        }
    }
}

