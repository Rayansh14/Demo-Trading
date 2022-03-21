//
//  BasicsGuide.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 19/02/22.
//

import SwiftUI

struct CustomRectangleLeft: View {
    var body: some View {
            Rectangle()
                .frame(width: 4)
                .foregroundColor(.gray)
    }
}

struct BasicsGuide: View {
    
    @ObservedObject var data = DataController.shared
    @State var imageRotated = false
    
    var body: some View {
        TabView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Why invest?")
                        .font(.custom("Poppins-Regular", size: 23))

                    Text("Before I tell you about the stock market, it would be useful for us to understand why one should invest in the first place. Let us consider two scenarios- One where a person invests his savings and another where he doesn't. ")

                    HStack {
                        CustomRectangleLeft()
                        VStack(alignment: .leading) {
                            Text("Assumptions")
                                .font(.custom("Poppins-Regular", size: 20))

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Name")
                                    Text("Current Age")
                                    Text("Retirement Age")
                                    Text("Monthly Salary")
                                    Text("Monthly Expenses")
                                    Text("Monthly Savings")
                                    Text("Yearly salary hike")
                                    Text("Yearly inflation")
                                    Text("Annual Return of scheme")
                                }
                                .font(.custom("Poppins-Regular", size: 15.5))

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("Rishi")
                                    Text("25 years")
                                    Text("55 years")
                                    Text("₹50,000")
                                    Text("₹30,000")
                                    Text("₹20,000")
                                    Text("10%")
                                    Text("8%")
                                    Text("13%")
                                }
                            }
                        }
                    }

                    HStack {
                        CustomRectangleLeft()
                        VStack(alignment: .leading) {
                            Text("Without Investing")
                                .font(.custom("Poppins-Regualr", size: 18))

                            Text("After 30 years of hard work, Rishi would have saved Rs. 5.79 Cr. Although that might sound impressive, it would only last Rishsi 9 years, assuming that his expenses continue to increase at 8% per year. At this stage, he would be 64 years old, with literally no savings or source of income. How does he fund his living at this stage?")
                        }
                    }

                    HStack {
                        CustomRectangleLeft()
                        VStack(alignment: .leading) {
                            Text("With Investing")
                                .font(.custom("Poppins-Regualr", size: 18))

                            Text("Had he invested his savings into a scheme that offered 13% return per year, he would have an astounding Rs. 25.3 Cr at the end of his working life! This is the benefit of investment. This translates to you being in a much better situation to deal with your post retirement life.")
                        }
                    }
                }
                .padding(.bottom, 50)
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("What to invest in?")
                        .font(.custom("Poppins-Regular", size: 23))
                    
                    Text("Now that we've established why one should invest, the next obvious question is what to invest in. When trying to make this decision, one has to choose an asset class that suits his risk profile and return expectation.\nAn asset class is a category of investment with particular risk and return characteristics.\nThere are 4 main asset classes:\n")
                    
                    AssetClassView(title: "Fixed Income", imageName: "piggy-bank", text: "Fixed income assests offer, as the name suggests, a fixed rate of return. These have almost no risk, and offer moderate returns consistently.\n8% CAGR is a good estimate for what you can expect to receive.")
                    
                    AssetClassView(title: "Equity", imageName: "stock-market-animation-1", text: "Investing in equites means buying shares of publicly listed company. Unlike in fixed income, there is no capital guarantee and the risk is quite high. However, this means that they can generate handsome returns.\nThe Indian Stock Market has generated a CAGR of around 14% over the last 15-20 years.")
                    
                    AssetClassView(title: "Real Estate", imageName: "real-estate-animation", text: "Investing in real estate means buying plots of land, either commercial or residential. There are two income sources from this category - rental and capital appreciation.\nTransacting in real estate is usually a long and tedious process. The cash required in such an investment is generally large. One cannot estimate the growth in real estate prices as they vary drastically from one area to another.")
                    
                    AssetClassView(title: "Gold", imageName: "gold-animation", text: "Gold and silver are some of the most popular investment avenues.\nGold has given an average return of 11% CAGR over the past 20 years.")
                    
                    Image(imageRotated ? "asset-class-comparison-rotated" : "asset-class-comparison")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: UIScreen.main.bounds.height/1.4)
                        .onTapGesture {
                            imageRotated.toggle()
                        }
                    
                    
                    
                }
                .padding(.bottom, 50)
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Shares")
                        .font(.custom("Poppins-Regular", size: 23))

                    Text("To understand the stock market, first you will have to understand shares.\nShares represent ownership in the company.")
                    HStack {
                        CustomRectangleLeft()
                        VStack(alignment: .leading) {
                            Text("Example")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("Company ABC has 10000 shares.\nIn this case, each share represents 0.01% ownership in the company. Someone owning 1000 shares would therefore own 10% of the company.")
                            Image("shares-pie-chart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    Text("Have you ever heard of somebody being a shareholder? A person who owns shares of a company is called a shareholder of that company.")

                }
                .padding(.bottom, 50)
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Public & Private Companies")
                        .font(.custom("Poppins-Regular", size: 23))
                    Image("public-vs-pvt-company")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("I'm sure you must have heard of public and private companies before and wondered what they are. The difference is pretty easy to understand. Public companies are those companies whose shares are traded publicly, and can be bought by the general public. Shares of private companies, on the other hand, are not traded publicly.")
                    HStack {
                        CustomRectangleLeft()
                        VStack(alignment: .leading) {
                            Text("Note")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("Shares of private companies can still be sold to individuals or corporations. However, they cannot be offered for sale to the general public.\n\nPeople holding shares in a company are essentaily partners in that company. Public companies have to publish detailed reports like their financial results, business models, etc so that their 'partners' can look at and study them.")
                            
                        }
                    }
                }
                .padding(.bottom, 50)
            }
            
            QuizView(question: "What is a public compnay?", optionsList: ["A company that has shares", "A company whose shares are not traded publicly", "A company whose shares can be traded by the general public", "A company that gives away its shares for free"], correctOption: 2, explanation: "")
            
            QuizView(question: "Company XYZ has 500 shares. Mani buys 50 shares of that company. What percentage of the compnay does he own?", optionsList: ["10%", "15%", "2%", "1%"], correctOption: 0, explanation: "Company XYZ has 500 shares, so each share represents 0.2% ownership in the company. 0.2 X 50 = 10%")
        }
        .padding(.horizontal)
        .font(.custom("Poppins-Light", size: 15.5))
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationTitle("Stock Market Basics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BasicsGuide_Previews: PreviewProvider {
    static var previews: some View {
        BasicsGuide()
    }
}


struct AssetClassView: View {
    var title: String
    var imageName: String
    var text: String
    
    var body: some View {
        HStack {
            VStack {
                
                Text(title)
                    .font(.custom("Poppins-Regular", size: 18))
            Image(imageName)
                .resizable()
                .frame(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
            }
            
            Text(text)
        }
        .padding(.bottom, 20)
    }
}
