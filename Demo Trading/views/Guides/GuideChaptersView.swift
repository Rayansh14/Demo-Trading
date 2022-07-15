//
//  GuideChaptersView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 26/03/22.
//
import SwiftUI

struct GuideDirectorView: View {
    
    var guideIndex: Int
    var chapterIndex: Int
    
    var body: some View {
        Group {
            switch guideIndex {
//            case 0:
//                GettingStartedGuide(chapterIndex: chapterIndex)
//                    .navigationTitle(gettingStartedGuide.chapterTitles[chapterIndex])
            case 1:
                BasicsGuide(chapterIndex: chapterIndex)
                    .navigationTitle(basicsGuide.chapterTitles[chapterIndex])
            case 2:
                TechnicalAnalysisGuide(chapterIndex: chapterIndex)
                    .navigationTitle(technicalGuide.chapterTitles[chapterIndex])
            case 3:
                FundamentalAnalysisGuide(chapterIndex: chapterIndex)
                    .navigationTitle(fundamentalGuide.chapterTitles[chapterIndex])
            case 4:
                EmptyView()
            default:
                EmptyView()
            }
        }
        .font(.custom("Poppins-Light", size: 15))
    }
}

struct GuideChaptersView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var guide: Guide
    
    var body: some View {
        ScrollView {
            
            HStack {
                VStack(alignment: .leading) {
                    Text(guide.title)
                        .font(.custom("Poppins-Regular", size: 22))
                    Text(guide.description)
                }
                .padding()
                .background(
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(30, corners: [.topRight, .bottomRight])
                        .opacity(0.8)
                )
                
                Image(guide.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width / 3)
                    .cornerRadius(15)
            }
            .padding(.trailing)
            .padding(.bottom)
            
            VStack(spacing: -15) {
                ForEach(-1..<guide.chapterTitles.count, id: \.self) { index in
                    HStack {
                        if index >= 0 {
                            NavigationLink(destination: GuideDirectorView(guideIndex: guide.index, chapterIndex: index)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(guide.chapterTitles.getElementOrDefault(index: index, defaultVal: "Chapter"))")
                                            .font(.custom("Poppins-Regular", size: 20))
                                        Text("\(guide.chapterPages.getElementOrDefault(index: index, defaultVal: 0)) Pages")
                                            .font(.custom("Poppins-Light", size: 15))
                                    }
                                    Spacer()
                                }
                                .padding(15)
                                .padding(.bottom, 15)
                                .background(
                                    LinearGradient(colors: getGradientColors(), startPoint: .top, endPoint: .bottom)
                                        .cornerRadius(25, corners: [.topLeft, .topRight])
                                        .foregroundColor(.white)
                                )
                                .foregroundColor(Color("Black White"))
                            }
                            .buttonStyle(FlatLinkStyle())
                        } else {
                            Text("")
                        }
                    }
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        //        .navigationTitle(guide.title)
    }
    
    func getGradientColors() -> [Color] {
        if colorScheme == .light {
            return [Color("White Black"), Color("White Black"), Color("Gradient Gray")]
        }
        return [Color("White Black"), Color("Light Gray")]
    }
    
    func getIndexOrDefault(array: [Any], index: Int, defaultVal: Any) -> Any {
        if array.count < index + 1 {
            return defaultVal
        }
        return array[index]
    }
}
//[Color("White Black"), Color("White Black"), Color("Gradient Gray")]
struct GuideChaptersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                GuideChaptersView(guide: basicsGuide)
            }
            NavigationView {
                GuideChaptersView(guide: basicsGuide)
            }
            .preferredColorScheme(.dark)
        }
        
    }
}
