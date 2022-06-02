//
//  Guides.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 12/02/22.
//

import SwiftUI

var gettingStartedGuide = Guide(index: 0, title: "Getting Started", imageName: "getting-started-animation", chapterTitles: ["001"], chapterPages: [8])

var basicsGuide = Guide(index: 1, title: "Stock Market Basics", imageName: "stock-market-animation", chapterTitles: ["Investing", "Shares", "Going Public", "Transacting in the Stock Market", "Major Events and Their Impacts", "Mutual Funds"], chapterPages: [4, 7, 5, 6, 3, 5], description: "The go-to guide for a complete beginner. From A to Z, this guide will help you get the knowledge you need to excel in the stock market.")

var technicalGuide = Guide(index: 2, title: "Technical Analysis", imageName: "candlesticks", chapterTitles: ["Introduction", "Single Candltesticks", "Multiple Candlesticks", "Moving Averages", "Chart Patterns"], chapterPages: [5], description: "If you’re looking to be a successful stock market trader, look no more. This guide will tell you all you need to know to get started.")

var fundamentalGuide = Guide(index: 3, title: "Fundamental Analysis", imageName: "fundamental-analysis-animation", chapterTitles: [], chapterPages: [], description: "The guide for people looking to generate wealth by investing in quality stocks for a long period of time.")

var derivativesGuide = Guide(index: 4, title: "Derivatives", imageName: "derivatives-animation", chapterTitles: [], chapterPages: [])

var guides = [gettingStartedGuide, basicsGuide, technicalGuide, fundamentalGuide, derivativesGuide]


struct Guides: View {
    
    private var gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    
                    ForEach(guides.sorted { $0.index < $1.index }) { guide in
                        
                        if guide.index == 0 {
                            ZStack {
                            NavigationLink(destination: GettingStartedGuide()) {
                                GuideTitleView(guide: guide)
                            }
//                            RoundedRectangle(cornerRadius: 313)
//                                .strokeBorder(.blue, lineWidth: 5)
//                                .frame(width: 200, height: 300)
                            }
                        }
                        
                        else {
                            NavigationLink(destination: GuideChaptersView(guide: guide)) {
                                if guide.imageName == "stock-market-animation" {
                                    GuideTitleView(guide: guide, imageFrameWidth: 120)
                                } else {
                                    GuideTitleView(guide: guide)
                                }
                            }
                            .opacity(data.isFirstTime ? 0.25 : 1)
                        }
                    }
                    
                }
                .padding(15)
            }
            .navigationTitle("Guides")
        }
    }
    
}


struct GuideTitleView: View {
    
    var guide: Guide
    var imageFrameWidth: CGFloat = 150
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .frame(width: 150)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5)
            VStack(spacing: 0) {
                
                Image(guide.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageFrameWidth, height: 110)
                    .cornerRadius(10, corners: [.topLeft, .topRight])
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                Text(guide.title)
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


struct Guide_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GuideTitleView(guide: basicsGuide)
            Guides()
            //                Guides()
            //                    .preferredColorScheme(.dark)
        }
    }
}

