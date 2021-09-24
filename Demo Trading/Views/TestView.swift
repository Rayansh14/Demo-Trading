////
////  StockDetailView.swift
////  Demo Trading
////
////  Created by Rayansh Gupta on 14/04/21.
////
//
//import SwiftUI
//
//struct StockDetailView: View {
//
//    var stockQuote: StockQuote
//    var showTitle: Bool
//    @ObservedObject var data = DataController.shared
//
//    var body: some View {
//        ZStack {
//            if !(stockQuote.symbol.contains("NIFTY")) {
//
//                VStack {
//
//                    HStack {
//                        VStack {
//                            Text("NSE: \(stockQuote.lastPrice.withCommas(withRupeeSymbol: true))")
//                            Text("\(String(format: "%.2f", stockQuote.pChange))%")
//                                .foregroundColor(stockQuote.pChange >= 0.0 ? .green : .red)
//                        }
//                        Spacer()
//                        if data.checkIfOwned(stockSymbol: stockQuote.symbol) {
//                            Text("\(Image(systemName: "briefcase.fill")) \(data.getNumberOwned(stockSymbol: stockQuote.symbol))")
//                        }
//                    }
//                    .padding(.horizontal, 35)
//                    .padding(.vertical)
//                    .font(.title2)
//
//
//
//                    HStack {
//
//                        Group {
//                            Spacer()
//                            VStack {
//                                Text("Open")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(Color(#colorLiteral(red: 0.2057823092, green: 0.2057823092, blue: 0.2057823092, alpha: 1)))
//                                Text(stockQuote.open.withCommas(withRupeeSymbol: true))
//                                    .padding(1)
//                            }
//                            Spacer()
//
//                            Divider()
//                                .frame(maxHeight: 75)
//                        }
//
//                        Group {
//                            Spacer()
//                            VStack {
//                                Text("Low")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(Color(#colorLiteral(red: 0.2057823092, green: 0.2057823092, blue: 0.2057823092, alpha: 1)))
//                                Text(stockQuote.dayLow.withCommas(withRupeeSymbol: true))
//                                    .padding(1)
//                            }
//                            Spacer()
//
//                            Divider()
//                                .frame(maxHeight: 75)
//                        }
//
//                        Group {
//                            Spacer()
//                            VStack {
//                                Text("High")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(Color(#colorLiteral(red: 0.2057823092, green: 0.2057823092, blue: 0.2057823092, alpha: 1)))
//                                Text(stockQuote.dayHigh.withCommas(withRupeeSymbol: true))
//                                    .padding(1)
//                            }
//                            Spacer()
//
//                            Divider()
//                                .frame(maxHeight: 75)
//                        }
//
//                        Group {
//                            Spacer()
//                            VStack {
//                                Text("Prev. Close")
//                                    .font(.system(size: 15))
//                                    .foregroundColor(Color(#colorLiteral(red: 0.2057823092, green: 0.2057823092, blue: 0.2057823092, alpha: 1)))
//                                Text(stockQuote.previousClose.withCommas(withRupeeSymbol: true))
//                                    .padding(1)
//                            }
//                            Spacer()
//                        }
//
//                    }
//                    .font(.system(size: 16))
//                    .multilineTextAlignment(.center)
//
////                    Spacer()
//
//                    HStack {
//                        NavigationLink(destination: TransactStockView(orderType: .buy, stockQuote: stockQuote, showTitle: showTitle)) {
//                            Text("Buy")
//                                .frame(width: 150)
//                                .foregroundColor(.white)
//                                .font(.title)
//                                .padding(.vertical, 10)
//                                .background(Color.green)
//                                .cornerRadius(10)
//                                .padding(.horizontal, 1)
//                        }
//                        NavigationLink(destination: TransactStockView(orderType: .sell, stockQuote: stockQuote, showTitle: showTitle)) {
//                            Text("Sell")
//                                .frame(width: 150)
//                                .foregroundColor(.white)
//                                .font(.title)
//                                .padding(.vertical, 10)
//                                .background(Color.red)
//                                .cornerRadius(10)
//                                .padding(.horizontal, 1)
//                        }
//                    }
//                    .padding(10)
//
//                    Spacer()
//                }
//
//            }
//            VStack {
//                Spacer()
//                ErrorTileView(error: data.errorMessage)
//                    .opacity(data.showError ? 1.0 : 0.0)
//                    .animation(.easeInOut)
//                    .padding(.bottom)
//            }
//        }
//        .if({
//            showTitle
//        }()) { view in
//            view.navigationTitle(stockQuote.symbol)
//        }
//        .if({
//            !showTitle
//        }()) { view in
//            view.navigationBarHidden(true)
//        }
//    }
//}
//
//
//
//
//struct TransactStockView: View {
//
//    var orderType: OrderType
//    var stockQuote: StockQuote
//    var showTitle: Bool
//    @StateObject var order = Order()
//    @State var numberOfShares = ""
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        VStack {
//            Text(orderType.rawValue.capitalized)
//            Text(String(stockQuote.lastPrice))
//            TextField("Number of shares", text: $numberOfShares)
//                .padding(5)
//                .border(Color("Black White"), width: 1)
//                .padding()
//                .keyboardType(.numberPad)
//            Button(action: {
//                order.type = orderType
//                order.sharePrice = stockQuote.lastPrice
//                order.stockSymbol = stockQuote.symbol
//                order.time = Date()
//                if let intNumberOfShares = Int(numberOfShares) {
//                    order.numberOfShares = intNumberOfShares
//                    DataController.shared.processOrder(order: order)
//                    presentationMode.wrappedValue.dismiss()
//                } else {
//                    DataController.shared.showErrorMessage(message: "Pls enter a valid number of shares.")
//                }
//            }) {
//                Text("Execute")
//                    .foregroundColor(.white)
//                    .font(.title)
//                    .padding(.vertical, 10)
//                    .padding(.horizontal)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .disabled(numberOfShares == "" ? true : false)
//        }
//        .if({
//            showTitle
//        }()) { view in
//            view.navigationTitle(stockQuote.symbol)
//        }
//        .if({
//            !showTitle
//        }()) { view in
//            view.navigationBarHidden(true)
//        }
//    }
//}
//
//
//struct StockDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            StockDetailView(stockQuote: testStockQuote, showTitle: true)
//        }
//    }
//}
