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
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    
                    NavigationLink(destination: BasicsGuide()) {
                        GuideTitleView(imageName: "stock-market-animation", title: "Stock Market Basics", imageFrameWidth: 120)
                    }
                    
                    NavigationLink(destination: TechnicalAnalysisGuide()) {
                        GuideTitleView(imageName: "candlesticks", title: "Technical Analysis")
                    }
                    
                    NavigationLink(destination: FundamentalAnalysisGuide()) {
                        GuideTitleView(imageName: "fundamental-analysis-animation", title: "Fundamental Analysis")
                    }
                    
                    GuideTitleView(imageName: "derivatives-animation", title: "Derivatives")
                }
                .padding(15)
            }
            .navigationTitle("Guides")
        }
    }
}


struct GuideTitleView: View {
    
    var imageName: String
    var title: String
    var imageFrameWidth: CGFloat = 150
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(width: 150)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5)
            VStack(spacing: 0) {
                
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageFrameWidth, height: 110)
                    .cornerRadius(10, corners: [.topLeft, .topRight])
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                Text(title)
                    .font(.custom("Poppins-Light", size: 18))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .background(
                        Rectangle()
                            .fill(.white)
                            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                            .frame(width: 150)
                    )
            }
        }
        .frame(width: 150)
        .padding(8)
    }
}

struct AltTitleView: View {
    
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
            AltTitleView(imageName: "fundamental-analysis-animation", title: "Fundamental Analysis")
            GuideTitleView(imageName: "fundamental-analysis-animation", title: "Fundamental Analysis")
            Guides()
            //                Guides()
            //                    .preferredColorScheme(.dark)
        }
    }
}

