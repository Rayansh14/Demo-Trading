//
//  TechnicalAnalysisGuide.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 19/02/22.
//

import SwiftUI

struct TechnicalAnalysisGuide: View {
    
    var chapterIndex: Int
    
    var body: some View {
        TabView {
            switch chapterIndex {
            case 0:
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("I'm sorry, what?")
                            .font(.custom("Poppins-Regular", size: 23))
                        
                        Text("Technical Analysis is probably something you have never heard of before, and definitely sounds more intimidating and complex than it really is.\n\nTechnical Analysis is a research technique to identify trading opportunities in the market based on market participants’ actions. The actions of market participants can be visualized, using a stock chart. Over time, patterns are formed within these charts, and each pattern conveys a certain message. The job of a technical analyst is to identify these patterns and develop a point of view.\n\nLike any research technique, technical analysis stands on a bunch of assumptions. As a technical analysis practitioner, you need to trade the markets keeping these assumptions in perspective. Of course, we will understand these assumptions in detail as we proceed along.")
                        
                        HStack {
                            CustomRectangleLeft()
                            VStack(alignment: .leading) {
                                Text("Note")
                                    .font(.custom("Poppins-Regular", size: 20))
                                Text("1. Trades")
                                    .font(.custom("Poppins-Regular", size: 18))
                                Text("Technical Analysis is best used to identify short term trades. Do not use it to identify long term investment opportunities.\n")
                                Text("2. Return per Trade")
                                    .font(.custom("Poppins-Regular", size: 18))
                                Text("TA based trades are usually short term in nature. Do not expect huge returns within a short duration of time. The trick with TA being successful is to identify frequent short-term trading opportunities that can give you small but consistent profits.\n")
                                
                                Text("3. Holding Period")
                                    .font(.custom("Poppins-Regular", size: 18))
                                Text("Trades based on technical analysis can last anywhere between few minutes and few weeks, and usually not beyond that. We will explore this aspect when we discuss the topic of timeframes.\n")
                                
                                Text("4. Risk")
                                    .font(.custom("Poppins-Regular", size: 18))
                                Text("Often, traders initiate a trade for a certain reason; however, in case of an adverse movement in the stock, the trade starts making a loss. Usually, in such situations, traders hold on to their loss-making trade with a hope they can recover the loss. Remember, TA based trades are short term, in case the trade goes sour, do remember to cut the losses and move on to identify another opportunity.")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Candlesticks")
                            .font(.custom("Poppins-Regular", size: 23))
                        
                        Text("The Japanese art of candlestick trading has been around for nearly 400 years. Japanese rice traders successfully used these signal formations to amass huge fortunes. Since then, the signals have been refined, tested and utilized in variety of markets. Wherever an instrument can be traded in an open market by traders, candlestick signals can be used to profit in such markets.\nThey visually show a trader the sentiments of the other traders in that particular stock or market.")
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                }
            default:
                Text("Error 404 Not Found.\nGo back to the previous page.")
            }
        }
        .applyGuideChars()
    }
}

struct TechnicalAnalysisGuide_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TechnicalAnalysisGuide(chapterIndex: 0)
        }
    }
}
