//
//  PortfolioView.swift
//  Demo Trading
//
//  Created by Rayansh Gupta on 21/02/22.
//

import SwiftUI

enum holdingsTabs: String {
    case positions, holdings
}

struct PortfolioView: View {
    @State var tabsShowing = true
    @State var selectedTab: holdingsTabs = .holdings
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    if tabsShowing {
                        HStack {
                            Spacer()
                            
                            VStack {
                                Text("Holdings")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(selectedTab == .holdings ? Color.blue : Color("Black White"))
                            }
                            .onTapGesture {
                                self.selectedTab = .holdings
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Positons")
                                    .foregroundColor(selectedTab == .positions ? Color.blue : Color("Black White"))
                            }
                            .onTapGesture {
                                self.selectedTab = .positions
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 3)
                            .offset(x: getXOffset(), y: 15)
                            .animation(.easeInOut(duration: 0.2), value: getXOffset())
                    }
                }
                
                if selectedTab == .holdings {
                    PortfolioListView(portfolioType: .holdings)
                } else {
                    PortfolioListView(portfolioType: .positions)
                }
            }
        }
    }
    
    func getXOffset() -> CGFloat {
        let width = UIScreen.main.bounds.width
        switch selectedTab {
        case .holdings:
            return -width/5
        case .positions:
            return width/5
        }
    }
    
    struct PortfolioView_Previews: PreviewProvider {
        static var previews: some View {
            PortfolioView()
        }
    }
}
