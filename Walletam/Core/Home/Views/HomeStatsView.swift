//
//  HomeStatsView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/7/22.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @ObservedObject var monitor = NetworkMonitor()
    @Binding var showPrices: Bool
    @State private var animationAmount = 0.3
    
    var body: some View {
        
        if showPrices {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.statistic) {stat in
                        StatisticView(stat: stat)
                            
                    }
                    .frame(width: UIScreen.main.bounds.width / 3,height: 70 ,alignment: .center)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.theme.background))
                        .shadow(color: Color.theme.shadowColor.opacity(0.3), radius: 5, x: 0, y: 0)
                        .padding(5)
                }
                
               .padding()
    //          .frame(//width: UIScreen.main.bounds.width,
    //            alignment: .leading)
            }
            .environment(\.layoutDirection, .rightToLeft)
        } else {
            portfolioOverview
        }
        
    }
}

//MARK: PREVIEW
struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPrices: .constant(false))
            .environmentObject(dev.homeVM)
//            .preferredColorScheme(.dark)
    }
}

extension HomeStatsView {
    
    var portfolioOverview: some View {
     
        VStack(alignment: .trailing, spacing: 0) {
            HStack{
                Spacer()
                VStack {
                    HStack {
                        if !monitor.isConnected {
                            Image(systemName: "wifi.slash")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color.theme.red)
                                .frame(width: 28, height: 28)
                                .padding(.horizontal, 5)
                        } else {
                            Image(systemName: "wifi.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .opacity(0)
                                .padding(.horizontal, 5)
                        }
                        Text("مجموع دارایی‌ها")
                            .font(Font.custom("BYekan+", size: 18))
                            .foregroundColor(Color.theme.SecondaryText)
                    }
                }
                
            }
            
            HStack {
                
                if vm.totalPortfolioCalc().isInfinite {
                    HStack {
                        VStack(alignment: .leading){
                            
                                Text("$ 1000")
                                    .font(Font.custom("BYekan+", size: 50))
                                Text("۳۰ ۰۰۰۰ تومان")
                                    .font(Font.custom("BYekan+", size: 25))
                        }
                        Spacer()
                    }
                    .redacted(reason: .placeholder)
                    .opacity(animationAmount)
                            .animation(Animation
                                        .easeInOut(duration: 1)
                                        .repeatForever(autoreverses: true), value: animationAmount)
                            .onAppear { animationAmount = 0.8 }
                } else {
                    HStack {
                        VStack(alignment: .leading, spacing: 5){
                            HStack{
                                Image(systemName: "dollarsign.circle.fill").resizable().frame(width: 40, height: 40)
                                Text("\(vm.totalPortfolioCalc().asTomanWith2Decimals())")
                                    .font(Font.custom("BYekan+", size: 50))
                                
                            }
                            HStack{
                                Text("تومان")
                                    .font(Font.custom("BYekan+", size: 25)).foregroundColor(Color.theme.SecondaryText)
                                
                                Text("\(vm.totalPortfolioToman().asTomanWith2Decimals())")
                                    .font(Font.custom("BYekan+", size: 25)).foregroundColor(Color.theme.SecondaryText)
                            }
                                .environment(\.locale, Locale.init(identifier: "fa_IR"))
                        }
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 10) {
                            HStack {
                                Text("")
                                Image(systemName: "bitcoinsign.circle.fill")
                                
                            }
                            HStack {
                                Text("")
                                Image(systemName: "creditcard.fill")
                            }
                            HStack {
                                Text("")
                                Image(systemName: "circlebadge.2.fill")
                            }
                        }
                    }
                }
                
                
            }
            
            
            
        }.padding().frame(width:UIScreen.main.bounds.width * 0.95).background(.ultraThinMaterial).cornerRadius(15).shadow(color: Color.theme.shadowColor.opacity(0.6), radius: 25, x: 0, y: 0).padding()
    
    }
}