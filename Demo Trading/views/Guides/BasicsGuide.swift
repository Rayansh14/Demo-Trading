//
//  BasicsGuide.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 19/02/22.
//

import SwiftUI

struct BasicsGuide: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        TabView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Shares")
                        .font(.custom("Poppins-Regular", size: 23))
                    Button(action: {data.faltu.toggle()}) {
                        Text("data")
                    }

                    Text("To understand the stock market, first you will have to understand shares.\nShares represent ownership in the company.")
                    HStack {
                        Rectangle()
                            .frame(width: 5)
                            .foregroundColor(.gray)
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
            }
            .padding(.bottom, 30)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Public & Private Companies")
                        .font(.custom("Poppins-Regular", size: 23))
                    Image("public-vs-pvt-company")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("I'm sure you must have heard of public and private companies before and wondered what they are. The difference is pretty easy to understand. Public companies are those companies whose shares are traded publicly, and can be bought by the general public. Shares of private companies, on the other hand, are not traded publicly.")
                    HStack {
                        Rectangle()
                            .frame(width: 5)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("Note")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("Shares of private companies can still be sold to individuals or corporations. However, they cannot be offered for sale to the general public.")
                            
                        }
                    }
                    HStack {
                        Rectangle()
                            .frame(width: 5)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("Note")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("People holding shares in a company are essentaily partners in that company. Public companies have to publish detailed reports like their financial results, business models, etc so that their 'partners' can look at and study them.")
                            
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            
            QuizView(question: "What is a public compnay?", optionsList: ["A company that has shares", "A company whose shares are not traded publicly", "A company whose shares can be traded by the general public", "A company that gives away its shares for free"], correctOption: 2, explanation: "")
            
            QuizView(question: "Company XYZ has 500 shares. Rishi buys 50 shares of that company. What percentage of the compnay does he own?", optionsList: ["10%", "15%", "2%", "1%"], correctOption: 0, explanation: "Company XYZ has 500 shares, so each share represents 0.2% ownership in the company. 0.2 X 50 = 10%")
        }
        .padding(.horizontal)
        .font(.custom("Poppins-Light", size: 16))
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
