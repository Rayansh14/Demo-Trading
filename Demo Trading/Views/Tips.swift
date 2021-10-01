//
//  Tips.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 30/09/21.
//

import SwiftUI

struct TipsView: View {
    
    @ObservedObject var data = DataController.shared
    
    var body: some View {
        ZStack {
//            Color.blue
//                .ignoresSafeArea()
            TabView {
                TipsPageView(title: "Welcome!", text: "500 companies + indices, 1,00,000 as fantasy money to trade stocks, prices are updated less often,", imageName: "t")
                TipsPageView(title: "Watchlist 👀", text: "This is your watchlist tab. You can add stocks to your watchlist by tapping on the search bar and searching for them. Once you've added stocks, they will appear on your watchlist. You can tap on a stock to get details about that stock and also trade (buy or sell) it.", imageName: "t")
                TipsPageView(title: "Order", text: "", imageName: "t")
                TipsPageView(title: "Positions", text: "", imageName: "t")
                TipsPageView(title: "Holdings", text: "", imageName: "t")
                TipsPageView(title: "Funds", text: "", imageName: "t")
                TipsPageView(title: "Delivery Margin", text: "", imageName: "t")
                TipsPageView(title: "Get Set, Go!", text: "now you know all the basics, start your journey on the stock maket, hopefully more ups and less downs, sometimes feel like pulling your hair out or something like that ig", imageName: "t")
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .navigationTitle("Welcome!")
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear(perform: {data.showTab=false})
//        .onDisappear(perform: {data.showTab=true})
    }
}


struct TipsPageView: View {
    
    var title: String
    var text: String
    var imageName: String
    
    var body: some View {
        VStack(spacing: 0) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(40)
            
            Spacer()
            
            
            HStack {
            Text(title)
                .font(.title)
                if title.lowercased().contains("watchlist") {
                    Image(systemName: "list.bullet")
                        .imageScale(.large)
                        .offset(x: -5, y: -1)
                }
                Spacer()
            }
            Text(text)
                
        }
        .padding()
        .padding(.horizontal, 5)
        .padding(.bottom, 25)
    }
}


struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        NavigationView {
            TipsView()
        }
//            NavigationView {
//            TipsPageView(title: "Welcome!", text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", imageName: "t")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .navigationTitle("Welcome")
//            }
        }
    }
}
