//
//  PortfolioListView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 19/04/21.
//

import SwiftUI

enum PortfolioType: String {
    case holdings, positions
}

struct PortfolioListView: View {
    
    @ObservedObject var data = DataController.shared
//    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    var portfolioType: PortfolioType
    @State private var buyValue = 0.0
    @State private var currentValue: Double = 0
    @State private var profitLoss: Double = 0
    @State private var profitLossPercent: Double = 0
    @State private var dayProfitLoss: Double = 0
    @State private var dayProfitLossPercent: Double = 0
    @State private var refresh = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("\(buyValue.withCommas())")
                                Text("Invested Amount")
                                    .font(.custom("Poppins-Light", size: 15))
                            }
                            .offset(x: -5)
                            
                            Spacer()
                            
                            VStack {
                                Text("\(currentValue.withCommas())")
                                Text("Current Value")
                                    .font(.custom("Poppins-Light", size: 15))
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        .font(.custom("Poppins-Regular", size: 25))
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.blue)
                        //                        .padding(.horizontal, 20)
                        
                        
                        HStack {
                            Text("P/L:")
                                .font(.custom("Poppins-Regular", size: 23))
                            Spacer()
                            Text("\(String(profitLoss.withCommas()))")
                                .font(.custom("Poppins-Regular", size: 23))
                                .foregroundColor(profitLoss >= 0 ? .green : .red)
                            Text("(\(String(profitLossPercent.withCommas()))%)")
                                .foregroundColor(profitLoss >= 0 ? .green : .red)
                        }
                        .padding(.horizontal, 30)
                    }
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("bg"))
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    if (portfolioType == .holdings ? data.holdings : data.positions).count == 0 {
                        ZStack {
                            
                            Image("share-certificate-png")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(Color.blue)
                                .opacity(0.9)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 30)
                                .aspectRatio(contentMode: .fit)
                            VStack {
                                Spacer()
                                Spacer()
                            }
                            
                        }
                    } else {
                        VStack {
                            
                            ForEach(portfolioType == .holdings ? data.holdings : data.positions) { stock in
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color("Divider Gray"))
                                PortfolioTileView(stock: stock, refresh: $refresh)
                            }
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color("Divider Gray"))
                            
                            Spacer()
                            if portfolioType == .holdings {
                                BarChart(refresh: $refresh)
                            }
                        }
                    }
                }
                
                
                if portfolioType == .holdings {
                    HStack {
                        Text("Today's P/L:")
                        Spacer()
                        Text("\(dayProfitLoss.withCommas(withRupeeSymbol: true)) (\(dayProfitLossPercent.withCommas())%)")
                            .foregroundColor(dayProfitLoss >= 0 ? .green : .red)
                    }
                    .font(.custom("Poppins-Light", size: 16))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 18)
                    .background(Color("Light Gray"))
                    .padding(.bottom, 1)
                }
                
            }
            .padding(.top, 20)
            //            .toolbar {
            //                ToolbarItem(placement: ToolbarItemPlacement.navigation) {
            //                    Text(portfolioType.rawValue.capitalized)
            //                        .font(.custom("Poppins-Light", size: 38, weight: .bold))
            //                        .foregroundColor(Color.blue)
            //                }
            //            }
            .navigationTitle(portfolioType == .holdings ? "Holdings" : "Positions")
            //            .navigationBarColor(colorScheme == .dark ? .black : .white , textColor: .systemBlue)
            //            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                updateAllPortfolioData()
            }) {
                Image(systemName: "gobackward")
            })
        }
//        .onReceive(timer, perform: { _ in
//            updateAllPortfolioData()
//        })
        .onAppear(perform: {
            updateAllPortfolioData()
        })
    }
    
    func updateAllPortfolioData() {
        refresh.toggle()
        data.updateAllStockPricesInPortfolio()
        let portfolioInfo = data.getPorfolioInfo(portfolio: portfolioType == .holdings ? data.holdings : data.positions)
        buyValue = portfolioInfo["buyValue"]!
        currentValue = portfolioInfo["currentValue"]!
        profitLoss = portfolioInfo["profitLoss"]!
        dayProfitLoss = portfolioInfo["dayProfitLoss"]!
        dayProfitLossPercent = dayProfitLoss*100/currentValue
        if buyValue == 0 {
            dayProfitLossPercent = 0
        } else {
            profitLossPercent = portfolioInfo["profitLossPercent"]!
        }
    }
}


struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PortfolioListView(portfolioType: .holdings)
                .preferredColorScheme(.dark)
            PortfolioListView(portfolioType: .positions)
                .preferredColorScheme(.dark)
        }
    }
}

//struct NavigationBarModifier: ViewModifier {
//  var backgroundColor: UIColor
//  var textColor: UIColor
//
//  init(backgroundColor: UIColor, textColor: UIColor) {
//    self.backgroundColor = backgroundColor
//    self.textColor = textColor
//    let coloredAppearance = UINavigationBarAppearance()
//    coloredAppearance.configureWithTransparentBackground()
//    coloredAppearance.backgroundColor = .clear
//    coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
//    coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
//
//    UINavigationBar.appearance().standardAppearance = coloredAppearance
//    UINavigationBar.appearance().compactAppearance = coloredAppearance
//    UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
//    UINavigationBar.appearance().tintColor = textColor
//  }
//
//  func body(content: Content) -> some View {
//    ZStack{
//       content
//        VStack {
//          GeometryReader { geometry in
//             Color(self.backgroundColor)
//                .frame(height: geometry.safeAreaInsets.top)
//                .edgesIgnoringSafeArea(.top)
//              Spacer()
//          }
//        }
//     }
//  }
//}
//
//extension View {
//  func navigationBarColor(_ backgroundColor: UIColor, textColor: UIColor) -> some View {
//    self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, textColor: textColor))
//  }
//}
