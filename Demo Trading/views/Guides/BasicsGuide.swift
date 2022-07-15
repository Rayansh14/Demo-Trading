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
    
    var chapterIndex: Int
    @State var imageRotated = false
    
    var body: some View {
        TabView {
            
            switch chapterIndex {
            case 0:
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Why invest?")
                            .font(heading1)
                        
                        Text("Before talking about the stock market, let's talk about why one should invest in the first place. Let us consider two scenarios- One where a person invests his savings and another where he doesn't.\n\nAssume that there is a 25 year old person named Rishi. Rishi earns ₹50,000 per month, out of which he spends 20,000. He is hoping to retire by the age of 55, which leaves him with 30 more years to earn.\n\nTo drive the point across, let us make a few simple assumptions about the inflation rate, Rishi's yearly salary hike, and the rate of return of the scheme which he invests in (how much does his invested money grow each year).")
                        
                        HStack {
                            CustomRectangleLeft()
                            VStack(alignment: .leading) {
                                Text("Assumptions")
                                    .font(heading2)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Name")
                                        Text("Current Age")
                                        Text("Retirement Age")
                                        Text("Monthly Salary")
                                        Text("Monthly Expenses")
                                        Text("Monthly Savings")
                                        Text("Yearly Salary Hike")
                                        Text("Yearly Inflation")
                                        Text("Annual Return of Scheme")
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
                                    .font(.custom("Poppins-Regular", size: 18))
                                
                                Text("After 30 years of hard work, Rishi would have saved Rs. 5.79 Cr. Although that might sound impressive, it would only last Rishi 9 years, assuming that his expenses continue to increase at 8% per year. At this stage, he would be 64 years old, with literally no savings or source of income. How does he fund his living at this stage?")
                            }
                        }
                        
                        HStack {
                            CustomRectangleLeft()
                            VStack(alignment: .leading) {
                                Text("With Investing")
                                    .font(.custom("Poppins-Regualr", size: 18))
                                
                                Text("If, instead of letting his money sit idle in a bank account, he had invested his savings into a scheme that offered 13% return per year, he would have an astounding Rs. 25.3 Cr at the end of his working life! This is the benefit of investing. With the decision to invest the surplus cash, your cash balance has increased significantly. This translates to you being in a much better situation to deal with your post retirement life.")
                            }
                        }
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("What to invest in?")
                            .font(heading1)
                        
                        Text("Now that we've established why one should invest, the next obvious question is what to invest in. When trying to make this decision, one has to choose an asset class that suits his risk profile and return expectation.\nAn asset class is a category of investment with particular risk and return characteristics.\nThere are 4 main asset classes:\n")
                        
                        AssetClassView(title: "Fixed Income", imageName: "piggy-bank", text: "Fixed income assests offer, as the name suggests, a fixed rate of return. These have almost no risk, and offer moderate returns consistently. However, the schemes offering the highest returns are generally not liquid and can only be redeemed after a set period of time i.e when your investment 'matures'. Liquidity refers to how easily an asset can be sold and converted into cash without affecting its value.\n8% CAGR is a good estimate for what you can expect to receive. (CAGR stands for 'Compounded Annual Growth Rate' and refers to how much the value of an asset increases every year.")
                        
                        AssetClassView(title: "Equity", imageName: "stock-market-animation-1", text: "Investing in equites means buying shares of publicly listed company. Unlike in fixed income, there is no capital guarantee and the risk is quite high. However, this means that they can generate handsome returns.\nThe Indian Stock Market has generated a CAGR of around 14% over the last 15-20 years.")
                        
                        AssetClassView(title: "Real Estate", imageName: "real-estate-animation", text: "Investing in real estate means buying plots of land, either commercial or residential. There are two income sources from this category - rental and capital appreciation.\nTransacting in real estate is usually a long and tedious process. The cash required in such an investment is generally large. One cannot estimate the growth in real estate prices as they vary drastically from one area to another.")
                        
                        AssetClassView(title: "Gold", imageName: "gold-animation", text: "Precious metals are some of the most popular investment avenues. Most households own a significant amount of gold and silver in the form of jewellery.\nGold has given an average return of 11% CAGR over the past 20 years.")
                        
                        Image(imageRotated ? "asset-class-comparison-rotated" : "asset-class-comparison")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: UIScreen.main.bounds.height/1.4)
                            .onTapGesture {
                                imageRotated.toggle()
                            }
                        
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Some things to remember")
                            .font(heading1)
                        Text("1. Risk and Return go hand in hand. Higher the risk, higher the return. Lower the risk; lower is the return.\n\n2. Investment in fixed income is a good option if you want to protect your principal amount. It is relatively less risky. However, you have the risk of losing money when you adjust for the inflation rate. Example – A fixed deposit which gives you 9% when the inflation is 10% means you are losing a net 1% per annum. Fixed-income investment is best suited for ultra risk-averse investors.\n\n3. Investment in Equities is a great option. It is known to beat inflation over a long period of time. Historically equity investment has generated returns close to 14-15%. However, equity investments can be risky.\n\n4. Real Estate investment requires a large outlay of cash and cannot be done with smaller amounts. Liquidity is another issue with real estate investment – you cannot buy or sell whenever you want. You always have to wait for the right time and the right buyer or seller to transact with you.\n\n5. Gold and silver are relatively safer, but the historical return on such investment has not been very encouraging.\n\n6. An optimal portfolio would consist of a mix of different asset classes to optimise returns and reduce risk. The amount invested in different assets would depend on one's risk profile, goals and time horizon. For example, a 25 year old employed individual will probably be willing to take more risk than a 60 year old individual nearing his retirement. Therefore, the younger person might allocate more of his portfolio to equity, as it is a high-risk, high-reward asset class.")
                    }
                    .guidePadding()
                }
                
                QuizView(question: "How does investing help?", optionsList: ["Creates a large corpus at the time of retirement", "Beats inflation", "Helps you sustain a desired lifestyle post retirment", "All of the above"], correctOption: 3, explanation: "")
                
                QuizView(question: "A person wishing to protect his capital would generally prefer to invest in: ", optionsList: ["Fixed Income", "Gold", "Equity", "Real Estate"], correctOption: 0, explanation: "Fixed income assests offer, as the name suggests, a fixed rate of return. These have almost no risk, and offer moderate returns consistently. They are a great option for a risk averse individual.")
                
                QuizView(question: "One should invest in:", optionsList: ["Gold", "Fixed Income", "Equity", "A mix of all of them"], correctOption: 3, explanation: "An optimal portfolio would consist of a mix of different asset classes to optimise returns and reduce risk.")
            case 1:
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Shares")
                            .font(heading1)
                        
                        Text("To understand the stock market, first one has to understand shares.\nShares represent a percentage of ownership in a company.")
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
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Public & Private Companies")
                            .font(heading1)
                        Image("public-vs-pvt-company")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("I'm sure you must have heard of public and private companies before and wondered what they are.\n\nPublic companies are those companies whose shares are traded publicly on stock exchanges, and can be bought by the general public. Shares of private companies, on the other hand, are not traded publicly.")
                        HStack {
                            CustomRectangleLeft()
                            VStack(alignment: .leading) {
                                Text("Note")
                                    .font(.custom("Poppins-Regular", size: 18))
                                Text("Shares of private companies can still be sold to individuals or corporations. However, they cannot be offered for sale to the general public and cannot be listed on stock exchanges.\n\nA public corporation is required to disclose certain information about itself to the general public. This is because anyone amongst the general public can buy shares of that company, thereby becoming a shareholder and essentially, a co-owner of that company. Such a person is entitled to know certain details like the financials, fundamentals, future plans, etc. of the company.")
                                
                            }
                        }
                    }
                    .guidePadding()
                }
                
                QuizView(question: "What is a public company?", optionsList: ["A company that has shares", "A company whose shares are not traded publicly", "A company whose shares can be traded by the general public", "A company that gives away its shares for free"], correctOption: 2, explanation: "Public companies are those companies whose shares are traded publicly on stock exchanges, and can be bought by the general public.")
                
                QuizView(question: "Company XYZ has 500 shares. Mani buys 50 shares of that company. What percentage of the company does he own?", optionsList: ["10%", "15%", "2%", "1%"], correctOption: 0, explanation: "Company XYZ has 500 shares, so each share represents 0.2% ownership in the company. 0.2 X 50 = 10%")
            case 2:
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Some Common Terms")
                            .font(heading1)
                        
                        Text("\nSEBI")
                            .font(.custom("Poppins-Regular", size: 17))
                        Text("The Securities and Exchange Board of India (SEBI) is a government body that regulates the trading of securities like stocks and bonds in India. It aims to protect the interests of the investors and curb fraudulent practices.")
                        
                        Text("\nMarket Cap")
                            .font(.custom("Poppins-Regular", size: 17))
                        Text("Market cap is the value of a company, as determined by people who trade its shares. It is calculated as the total number of shares of that company multiplied by the price of 1 share. For example, if Company XYZ has 500 shares and the price of one share is ₹20, then the market cap of the company is ₹20 X 500 = ₹10,000.")
                        
                        Text("\nLots")
                            .font(.custom("Poppins-Regular", size: 17))
                        Text("A lot is a fixed number of shares of a company that are traded as one unit. A simple example of lot is: when we buy a pack of six chocolates, it refers to buying a single lot of chocolate. The shares of a company can usually be traded individually, however there are some scenarios when only lots can be traded.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Why public?")
                            .font(heading1)
                        Text("A question that might come to your mind is why a company would want to go public. Usually, a company goes public because of one of the following reasons:\n")
                        
                        Group {
                            Text("1. Raise Money")
                                .font(.custom("Poppins-Regular", size: 17))
                            Text("Going public is the cheapest way of raising funds. This is because money raised by going public does not need to be paid back. A company is essentially selling a part of the ownership of their company and so the money they receive does not have to be given back. The alternative way to raise money would be through debt i.e by getting a loan from a bank. But, this amount plus interest would have to be paid back to the bank at a later date. Therefore, in many cases, going public is a good way to raise a large amount of funds, which is generally used by the company to expand into new markets and invest in facilities.\n")
                            
                            Text("2. Pay Off Debt")
                                .font(.custom("Poppins-Regular", size: 17))
                            Text("Another major reason for going public is to pay off debt. By paying off loans early, a company potentially saves hundreds of crores due to having to pay less interest.\n")
                            
                            Text("3. Unlock Value for Existing Shareholders")
                                .font(.custom("Poppins-Regular", size: 17))
                            Text("A lot of times, a company goes public to give existing shareholders a chance to sell their stake and cash out. It thus provides an exit route for them and lets promoters and early investors liquidate their shares.\n")
                            
                            Text("4. Visibility and credibility")
                                .font(.custom("Poppins-Regular", size: 17))
                            Text("Going public can be a terrific branding event for a company. Going public creates a lot of media coverage. The company can leverage this in a number of different ways to help the business grow and expand.")
                        }
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("How To Go Public - IPOs")
                            .font(heading1)
                        Text("When a company decides to go public, it does so by an Initial Public Offering (IPO). In an IPO, the existing shareholders of a company offer their shares for sale to the general public at a fixed price band.")
                        
                        Image("ipo-animation")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        HStack {
                            CustomRectangleLeft()
                            VStack(alignment: .leading) {
                                Text("Example")
                                    .font(heading2)
                                Text("Mrs. Bectors' Food Specialities recently went public on December 15, 2020. The funds raised would be utilised for the expansion of its Rajpura manufacturing facility by establishing a new production line for biscuits. \nShares worth ₹540 Cr were sold at the price of ₹288 per share.")
                            }
                        }
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Group {
                            Text("Sequence of Events - Part 1")
                                .font(heading1)
                            Text("Each and every step involved in the IPO sequence has to happen under the SEBI guidelines. In general, the following are the sequence of steps involved.\n")
                            
                            Text("1. Get Approval From SEBI")
                                .font(.custom("Poppins-Regular", size: 17))
                            Text("First, the company needs to file a registration statement with SEBI, which contains details on what the company does, why the company plans to go public and the financial health of the company. Once SEBI receives the statement, it takes a call on whether to allow the IPO to take place or not.\n")
                            
                            Text("2. Market the IPO")
                                .font(.custom("Poppins-Regular", size: 17))
                            Text("Assuming that SEBI gives its approval, the next step would be for the company to publish TV and print advertisements in order to build awareness about the company and its IPO offering. This process is also called the IPO roadshow.\n")
                            
                            Text("3. Fix the Price Band")
                                .font(.custom("Poppins-Regular", size: 17))
                            Text("Next, the compnany has to fix the price band of the IPO. This is a very important stage as the company wants to sell its shares at the highest price possible while making sure that the offering gets fully subscribed. For this purpose, merchant bankers are employed who study the businesses's financials, future prospects, assets, etc and determine a fair value for the share.\n")
                        }
                        
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        Text("Sequence of Events - Part 2")
                            .font(heading1)
                        
                        Text("4. Book Building")
                            .font(.custom("Poppins-Regular", size: 17))
                        Text("Once the roadshow is done and the price band fixed, the company now has to officially open the window during which the public can subscribe for shares. For example, if the price band is between Rs.100 and Rs.120, then the public can actually choose a price they think is fair enough for the issue. A person offering to buy shares in an IPO is referred to as 'subscribing' to the IPO.")
                        
                        HStack {
                            CustomRectangleLeft()
                            VStack(alignment: .leading) {
                                Text("Example")
                                    .font(.custom("Poppins-Regular", size: 18))
                                Text("A company ASD decides to raise capital for business expansion by making the company public. Of course, they hire a merchant banker who analyzes the company’s future prospects and its net worth, among other things, to evaluate what price band would be suitable for the IPO, i.e. how much investors would be willing to pay for a share.\n\nASD has decided to issue 10,000 shares in its IPO. After a thorough analysis by the merchant banker, the price band is decided to be in the Rs. 100-Rs. 110 range. Investors interested in buying the shares of ASD are requested to send in their bids within a predetermined time period. The bids received by investors are above or equal to the floor price, i.e., Rs. 100.\n\nBids for 3,000 shares are received at Rs. 100, for 6,000 shares at Rs. 105 and for 4,000 shares at Rs. 110.\n\nAfter the bid window is closed, the final price, i.e., the cut-off price depends on the number of bids received at each price. In ASD's case, to issue all 10,000 shares, the minimum price will be Rs. 105, because bids for 6,000 and 4,000 shares (which adds up to 10,000 shares) were received at or above Rs. 105. The company will refund money to those who bid at Rs. 100, and it will refund the balance amount to those who bid at Rs. 110.")
                            }
                        }
                        Text("In an IPO, a person can only bid for lots, not for individual shares. Usually, the combined value of the shares in a lot is around ₹15,000.\n")
                        
                        Text("5. Allotment of shares")
                            .font(.custom("Poppins-Regular", size: 17))
                        Text("When a company receives bids for more shares than it is selling, the issue is said to be oversubsribed. In this case, shares are allocated using a lucky draw system. Every investor will get no more than one lot, regardless of the number of lots he bid for. Also, an investor will always receive a complete lot as lots cannot be split in an IPO.\n")
                        
                        Text("6. Listing Day")
                            .font(.custom("Poppins-Regular", size: 17))
                        Text("This is the day when the company is actually listed on the stock exchanges. The listing price is decided based on market demand and supply on that day.\n")
                    }
                    .guidePadding()
                }
                
                QuizView(question: "The main reason for a company to file for an IPO is:", optionsList: ["Fund expansion", "Provide an exit for early investors in the company", "Repay Debt", "Can be any of the above"], correctOption: 3, explanation: "A company may go public to raise capital for exansion, unlock value for existing shareholders, repay debt or improve its visibility and credibility.")
                
                QuizView(question: "What does SEBI do?", optionsList: ["Protect the interests of the investor", "Approves IPOs", "Prevent fraud", "All of the above"], correctOption: 3, explanation: "The Securities and Exchange Board of India (SEBI) is a government body that regulates the trading of securities like stocks and bonds in India. It aims to protect the interests of the investors and curb fraudulent practices. Approving IPOs is one of its many functions.")
                
                QuizView(question: "In case of an oversubsription, shares are alloted using which method?", optionsList: ["First come first serve", "Lucky draw", "Last come first serve", "None of the above"], correctOption: 1, explanation: "In an oversubscription, shares are allocated using a lucky draw system. Every investor will get no more than one lot, regardless of the number of lots he bid for. An investor will always receive a complete lot, never one which has been split.")
                
            case 3:
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Stock Exchanges")
                            .font(heading1)
                        
                        Text("This is where the shares of companies are traded. Stock exchanges are the platforms which connect the buyers and the sellers and allow for the easy and seamless transaction of shares. Like Whatsapp is a platform for you to talk to your friends, the same way stock exchanges are platforms for you to make transactions with buyers and sellers.\n\nAll major countries have their own stock exchanges. Some large countries, like the USA, even have multiple stock exchanges.\n\nThere are two stock exchanges in India – NSE (National Stock Exchange) and BSE (Bombay Stock Exchange). In India, the stock market is often referred to as 'Dalal Street' because that's where the BSE, India's oldest stock exchange, is located.")
                        
                        HStack {
                            Image("nse")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Image("bse")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        
                        .padding(.vertical, 5)
                        
                        Text("The stock exchanges in India are open every weekday from 9:15 a.m. to 3:30 p.m. except on specific national and cultural holidays.\nThere is a pre-market session from 9:00 a.m. to 9:15 a.m. before the regular session starts. This is there to reduce the price volatility and arrive at an opening price for each stock.\nThere is also a post-market session from 3:40 p.m. to 4:00 p.m., however this is not usually very active. The closing price of a stock is determined in the post market session.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Stockbroker")
                            .font(heading1)
                        
                        Image("stockbroker")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Text("A stockbroker is your gateway to stock exchanges. It is an intermediary who has the authority to buy and sell stocks and securities in a stock exchange on the investor’s behalf.\n\nStocks are traded through exchanges. However, an investor cannot directly interact with stock exchanges. To buy a stock or sell a stock through an exchange, you need an intermediary who will help you with the transaction. Such a company is known as a stockbroker. A stockbroker is registered as a trading member with the stock exchange and holds a stockbroking license. For providing this service, a stockbroker charges a commission or a fee. In India, there are many stockbrokers like Zerodha, Angel Broking, Groww, etc.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Depository")
                            .font(heading1)
                        
                        Text("When you buy shares, these shares sit in your Depository account, usually referred to as the DEMAT account. This is maintained electronically by only 2 companies in India: Central Depository Services Limited (CDSL) and National Securities Depository Limited (NSDL). The depositories act like a vault for the shares that you buy.")
                        Image("vault-animation")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("The depositories hold your shares and facilitate the exchange of your securities. Think of the depository as this way - like how a bank is to your money, the depository is to your shares. The depositories' main job is the safekeeping of shares.\n\nLike the stock exchanges, the depositories are not client-facing. This means that one cannot directly interact with them. One can only interact with them through Depository Participants. Most of the stock brokers also double up as a Depository Participant.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Clearance and Settlement")
                            .font(heading1)
                        
                        Text("In India, it used to take 2 business days for a transaction to be completed. This is known as T+2 settlement. However, both the NSE and BSE are gradually shifting to T+1 settlement, which means that it will only take 1 business day to settle a transaction. The following is and example of how T+1 settlement works.")
                        
                        HStack {
                            CustomRectangleLeft()
                            VStack(alignment: .leading) {
                                Text("Example")
                                    .font(heading2)
                                Text("You buy 1 share of Reliance on Monday for Rs. 2500. This is called trade day or ‘T’. As soon as you buy the share, the amount is debited from your account. However, you will only receive the share in your depository account (demat account) the next day i.e Tuesday. This is called T+1 settlement.\n\nIf you are selling a share, you will only be able to withdraw the money earned from the sale the next day. However, you can use 80% of the money received instantly for new trades. The remaining 20% (known as delivery margin) will be available the next day.\n\nFor example, I sell 10 shares of Infosys @ Rs.1500 each on Thursday. The total sale value is Rs. 15,000. In this case, I am able to use 80% of the amount i.e Rs. 12,000 for buying more shares instantly after the sale. I will be able to use the remaining 20% i.e Rs. 3000 the next day (Friday). However, if I want to withdraw the money to my bank account, I will have to wait until the day after the transaction (t+1), when I will be able to withdraw 100% of my money.")
                            }
                        }
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Indices")
                            .font(heading1)
                        Text("An index is a collection of stocks which helps track their collective price performance. Most indices are market cap weighted, which means that the companies with the biggest market cap have the highest weightage (influence). Nifty and Sensex are the major indices in India. Nifty50 comprises of the top 50 companies of India by market cap, while Sensex comprises of the top 30 companies.")
                        Image("index-animation")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 25)
                        Text("More specifically, these indices depend on the free float market cap of their constituents. The free float market cap is calculated by multiplying the share price by the number of shares readily available in the market. Rather than using all of the shares, as is the case with the full-market capitalization method, the free-float method excludes locked-in shares, such as those held by insiders, promoters, and governments.\n\nThis is why HDFC Bank has a higher weightage in Nifty than TCS. Even though TCS's market cap is higher, HDFC Bank has more shares readily available in the market, which leads to a higher free float market capitalisation.\n\nApart from Nifty50 and Sensex, there are also sectoral indices like Nifty IT, which comprises of major IT companies, and broad indices like Nifty 500, which comprises of the top 500 companies of India by market cap.")
                    }
                    .guidePadding()
                }
                
                QuizView(question: "An individual can directly interact with stock exchanges and depositories.", optionsList: ["True", "False"], correctOption: 1, explanation: "Stock exchanges and depositories are not client-facing. This means that an individual cannot directly interact with them. One has to through an intermediary i.e a stockbroker.")
                QuizView(question: "The number of companies in Sensex and Nifty respectively are:", optionsList: ["30 and 50", "35 and 45", "50 and 100", "Keeps changing every year"], correctOption: 0, explanation: "Nifty and Sensex are the major indices in India. Nifty50 comprises of the top 50 companies of India by market cap, while Sensex comprises of the top 30 companies.")
                QuizView(question: "Stocks of companies are traded on ", optionsList: ["Depositories", "Bank Account", "Stock Exchange"], correctOption: 2, explanation: "Stock exchanges are the platforms which connect the buyers and the sellers and allow for the easy and seamless transaction of shares. All major countries have their own stock exchanges.")
                
            case 4:
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Dividend")
                            .font(heading1)
                        Image("dividend")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Text("Dividends are payments made by the company to its shareholders. The dividends are paid to distribute the profits made by the company and to reward shareholders for their confidence in the stock.\n\nIt is not mandatory for a company to pay dividends. If it feels that it is better off utilising the cash to fund expansion or capital expenditure, it can do so.\n\nA company is also not required to pay dividends from its profits only. Even a loss making company can pay a dividend from its cash reserves if it chooses to.\n\nUsually, the share price of a company decreases by the dividend amount after it has been paid. This is because the money that it used to pay the dividend is no longer with the company, so it is deducted from its value. For example, if TCS gives a dividend of Rs. 70 per share, you can expect its share price to go down by around Rs. 70 as well.\n\nThe following are some important dates regarding a dividend:\n\n")
                        + Text("Dividend Declaration Date: ")
                            .font(.custom("Poppins-Regular", size: 17))
                        + Text("This is the date when the board of the company approves the dividend.\n\n")
                        + Text("Record Date: ")
                            .font(.custom("Poppins-Regular", size: 17))
                        + Text("This is the date when the company decides to check the list of shareholders who will receive the dividend.\n\n")
                        + Text("Ex-Date:")
                            .font(.custom("Poppins-Regular", size: 17))
                        + Text(" In India, this is set 2 business days before the record date because of T+2 settlement. Only shareholders who own the stock before this day will be eligible for the dividend.\n\n")
                        + Text("Dividend Payout Date:")
                            .font(.custom("Poppins-Regular", size: 17))
                        + Text(" This is the date when the dividend is paid to the eligible shareholders.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Stock Split")
                            .font(heading1)
                        Image("stock-split")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Text("A stock split is exactly what it sounds like. Each share gets split into many more shares, but the total market capitalization remains the same. Stock splits occur in fixed ratios, such as 1:2, 1:5, etc. In 1:2 split, each share is split into 2 shares, and the price of 1 share halves.\n\nFor example, if a company whose shares are trading at ₹5000 undergoes a 1:2 split, each share would be divided into 2 shares and the value of 1 share would be 5000 ÷ 2 = 2500. Similarly, if the company had undergone a 1:5 split, the value of 1 share would be 5000 ÷ 5 = 1000. \n\nWhen the share price of a company becomes too high, it becomes tough for individual investors (also called retail investors) to buy shares. A stock split reduces the share price, thereby increasing retail participation and liquidity of the share.")
                    }
                    .guidePadding()
                }
                
                //                ScrollView {
                //                    VStack(alignment: .leading) {
                //                        Text("Bonus")
                //                            .font(heading1)
                //                        Image("bonus")
                //                            .resizable()
                //                            .aspectRatio(contentMode: .fit)
                //                    }
                //                    .guidePadding()
                //                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Buyback")
                            .font(heading1)
                        Image("buyback")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text("A buyback is when the company buys its own shares from existing shareholders. It is a method for the company to invest in its own stock. This is seen as a very positive sign as it reflects the company’s confidence in its share price and ability to grow. \n\nIn a buy back, there is no compulsion for investors to sell their shares. To entice shareholders to opt for the buyback, the company offers to buy its shares at a price much higher than the market price.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Rights Issue")
                            .font(heading1)
                        Text("A rights issue is a mechanism for a public company to raise additional funds. However, instead of approaching the general public, it approaches its existing shareholders. In a rights issue, existing shareholders are given the right to buy more shares of the company in proportion to shares they already own.")
                        
                        HStack {
                            CustomRectangleLeft()
                            VStack(alignment: .leading) {
                                Text("Example")
                                    .font(.custom("Poppins-Regular", size: 20))
                                Text("I own 50 shares of Infosys and it comes out with a 1:10 rights issue, I will be able to purchase 1 more share for every 10 that I already own, so I will be able to buy 5 shares in total.")
                            }
                        }
                        
                        Text("The shares in a rights issue are obviously priced much lower than the market price, so that shareholders benefit from subscribing to a rights issue as opposed to just purchasing directly from the stock exchange.\n\nEligible shareholders have a couple of options in a rights issue. They can either subscribe to the rights issue partly or fully; or can let the offer lapse by not exercising their rights to purchase the additional shares; or can sell their rights to other people.")
                    }
                    .guidePadding()
                }
                
                /*
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Budget")
                            .font(heading1)
                        Text("A Budget is an event during which the Ministry of Finance discusses the country’s finance in detail. The Finance Minister, on behalf of the ministry, makes a budget presentation to the entire country. The areas where the government will spend its tax revenue are discussed in the budget. During the budget, major policy announcements and economic reforms are announced, which impacts various industries across the country. Therefore it plays a vital role in the economy and influences the stock market to a great degree.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Monetary Policy")
                            .font(heading1)
                    }
                    .guidePadding()
                }
                 */
                
                QuizView(question: "What impact does a buyback have on the company's share price?", optionsList: ["Share prices generally go down", "Share prices generally go up", "Share prices are not affected by buybacks"], correctOption: 1, explanation: "A buyback is seen as a very positive sign as it reflects the company’s confidence in its share price and ability to grow.")
                QuizView(question: "The profit made by a company is distributed to its shareholders by", optionsList: ["Rights Issue", "Stock Split", "Dividend", "None of these"], correctOption: 2, explanation: "Dividends are payments made by the company to its shareholders. The dividends are paid to distribute the profits made by the company and to reward shareholders for their confidence in the stock.")
                
                
            case 5:
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("What is a Mutual Fund?")
                            .font(heading1)
                        
                        Text("A mutual fund is made up of a pool of money collected from many investors to invest in stocks, bonds, and other assets. Mutual funds are operated by professional money managers, who allocate the fund's assets and attempt to produce capital gains or income for the fund's investors.\n\nMost people prefer to invest in mutual funds because it requires little effort or knowledge from the investor, and it is managed by experts.")
                        
                        Image("mutual-fund-workings")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Text("In return for providing their expertise and allocating, managing and advertising the fund to maximise returns and manage risks, mutual funds charge a fee called the expense ratio. The expense ratio varies drastically from one fund to another. Usually, it is in the range of 1-2.5% of the amount per year.\n\nExpense ratios are often not given enough importance and their effect on returns is underestimated. For example, you invest 1 lakh each in two mutual funds - one has an expense ratio that is 1% higher than the other. Both of them have the exact same portfolio composition, and the one with a lower expense ratio gives a return of 15% per year, while the other returns 14% per year. After 25 years, the value of your investment in the higher expense ratio fund would be 26.4 Lakh, while your investment in the fund with a lower expense ratio would be 32.9 Lakh. That is a huge gap, especially considering that fact that the only difference between the two is a 1% higher expense ratio.")
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Types of Mutual Funds")
                            .font(heading1)
                            .padding(.bottom, 0.1)
                        
                        Group {
                            Text("Based on Asset Class")
                                .font(heading2)
                            
                            Text("Equity Funds")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("Equity funds primarily invest in stocks, and hence go by the name of stock funds as well. The gains and losses associated with these funds depend solely on how the invested shares perform in the stock market. Equity funds have the potential to generate significant returns over a period. Hence, the risk associated with these funds also tends to be comparatively higher.\n")
                            
                            Text("Debt Funds")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("Debt funds invest primarily in fixed-income securities such as bonds and treasury bills. Since the investments come with a fixed interest rate and maturity date, it can be a great option for passive investors looking for regular income with minimal risks.\n")
                            
                            Text("Hybrid Funds")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("As the name suggests, hybrid funds are an optimum mix of bonds and stocks, thereby bridging the gap between equity funds and debt funds.")
                            
                            Image("mf-asset-class")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.horizontal, 50)
                        }
                        
                        Group {
                            Text("\nDirect and Regular Plans")
                                .font(heading2)
                            
                            Text("Direct Mutual Funds")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("Direct Mutual Funds is the type of mutual fund that is directly offered by the AMC (Asset Management Company) or fund house. In other words, there is no involvement of third party agents – brokers or distributors. Since there are no third party agents involved, there are no commissions and brokerage. Hence the expense ratio of a direct mutual fund is lower.\n")
                            
                            Text("Regular Mutual Funds")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("Regular plans are those mutual fund plans that are bought through an intermediary. These intermediaries can be brokers, advisors, or distributors. The expense ratio for regular mutual funds is slightly higher than direct mutual funds.\n")
                            
                            Text("Direct vs Regular")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("Both the options – direct plan and regular plan invest in exactly the same assests in exactly the same ratios. However, the major difference is that in a regular plan, the fund house pays commission as a distribution fee. While in the direct plan, there is no such commission or fee. So, the returns generated by a direct plan will always be higher than those generated by a regular plan. However, for a person who is not well versed with investing, regular plans are a great option as well because they allow the person to get professional advice from a qualified advisor.\n\n")
                        }
                        
                        Group {
                            Text("Growth and IDCW Funds")
                                .font(heading2)
                            
                            Text("IDCW Funds")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("IDCW stands for 'Income Distribution cum Capital Withdrawal'. Here, a part of a person's investment is paid to out to him as dividends, at pre-decided intervals. This option is suitable for people who have no current source of income and are looking to live off their investments.\n")
                            
                            Text("Growth Funds")
                                .font(.custom("Poppins-Regular", size: 18))
                            Text("In growth funds, profits earned are reinvested in the scheme, and no dividend payout takes place. Here, you stand a chance to take advantage of compounding by earning profits on profits.")
                        }
                    }
                    .guidePadding()
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Systematic Plans")
                            .font(heading1)
                        
                        Text("SIP")
                            .font(heading2)
                        Text("SIP stands for 'Sytematic Investment Plan'. It is an investment plan in which a fixed amount is invested into a mutual fund at regular intervals- say once a month or once a quarter. It’s convenient as you can give your bank standing instructions to debit the amount every month.\n")
                        
                        Text("Benefits of SIP")
                            .font(.custom("Poppins-Regular", size: 17))
                        Text("SIP has been gaining popularity among MF investors, as it helps in investing in a disciplined manner without worrying about market volatility and timing the market. It reduces the risk as one is buying both when the market is high and when it is low. Systematic Investment Plans offered by Mutual Funds are easily the best way to enter the world of investments for the long term.\n\n")
                        
                        Text("STP")
                            .font(heading2)
                        Text("STP(Systematic Transfer Plan) means transferring money from one mutual fund plan to another. STP is a smart strategy to stagger your investment over a specific term to reduce risks and balance returns. In most cases, investors initiate an STP from a debt fund to an equity fund.\n\n")
                        
                        Text("SWP")
                            .font(heading2)
                        Text("SWP or systematic withdrawal plan is a mutual fund investment plan, through which investors can withdraw fixed amounts at regular intervals. SWP in mutual funds facilitates investors by providing a regular income from their investments.")
                        
                    }
                    .guidePadding()
                }
                
                QuizView(question: "SIP is a ", optionsList: ["Name of a Mutual Fund", "Method of regular investment", "Brand of tea stock", "None of these"], correctOption: 1, explanation: "SIP stands for 'Sytematic Investment Plan'. It is an investment plan in which a fixed amount is invested into a mutual fund at regular intervals")
                QuizView(question: "The fees charged by the mutual fund company to manage money on your behalf is called ", optionsList: ["Corpus", "Fees", "Load", "Expense Ratio"], correctOption: 3, explanation: "In return for providing their expertise and allocating, managing and advertising the fund to maximise returns and manage risks, mutual funds charge a fee called the expense ratio.")
                
            default:
                Text("Error 404 Not Found.\nGo back to the previous page.")
            }
            
        }
        .applyGuideChars()
    }
}

struct BasicsGuide_Previews: PreviewProvider {
    static var previews: some View {
        BasicsGuide(chapterIndex: 0)
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
