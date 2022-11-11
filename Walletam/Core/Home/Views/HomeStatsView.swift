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
            cryptoMarketOverview
        } else {
            portfolioOverview
        }
    }
}

//MARK: EXTENSIONS
extension HomeStatsView {
    
    //MARK: VIEWS
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
                        Text("total_assets")
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
                                Text(vm.translateState ? "\(vm.totalPortfolioCalc().asDollarWithTwoDecimalsEng())" : "\(vm.totalPortfolioCalc().asTomanWith2Decimals())")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                                    .font(Font.custom("BYekan+", size: 50))
                                
                            }
                            HStack{
                                Text("toman_sign")
                                    .font(Font.custom("BYekan+", size: 15)).foregroundColor(Color.theme.SecondaryText)
                                
                                Text(vm.translateState ? "\(vm.totalPortfolioToman().asTomanWithTwoDecimalsEng())" : "\(vm.totalPortfolioToman().asTomanWith2Decimals())")
                                    .font(Font.custom("BYekan+", size: 15)).foregroundColor(Color.theme.SecondaryText)
                            }
                        }
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 10) {
                            HStack(spacing: 2) {
                                if vm.showCurrencyChange {
                                    Text("toman_sign")
                                        .font(Font.custom("BYekan+", size: 15)).foregroundColor(Color.theme.SecondaryText)
                                    Text(vm.translateState ? "\(vm.cryptoTotalAsToman().asTomanWithTwoDecimalsEng())": "\(vm.cryptoTotalAsToman().asTomanWith2Decimals())")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .font(Font.custom("BYekan+", size: 15)).foregroundColor(Color.theme.SecondaryText)
                                    
                                } else {
                                    Text(vm.translateState ? "\(vm.cryptoTotalCalc().asDollarWithTwoDecimalsEng())" : "\(vm.cryptoTotalCalc().asCurrencyWith2Decimals())")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .font(Font.custom("BYekan+", size: 15)).foregroundColor(Color.theme.SecondaryText)
                                    
                                }
                                
                                Image(systemName: "bitcoinsign.circle.fill")
                                
                            }
                            HStack {
                                
                                if vm.showCurrencyChange {
                                    HStack(spacing: 2) {
                                        Text("toman_sign")
                                            .font(Font.custom("BYekan+", size: 15)).foregroundColor(Color.theme.SecondaryText)
                                        Text(vm.translateState ? "\(vm.irPrice?.asTomanWithTwoDecimalsEng() ?? "")" : "\(vm.irPrice?.asTomanWith2Decimals() ?? "")")
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.1)
                                            .font(Font.custom("BYekan+", size: 15)).foregroundColor(Color.theme.SecondaryText)
                                        
                                        
                                    }
                                } else {
                                    Text(vm.translateState ? "\(vm.tomanTotalAsDollar().asDollarWithTwoDecimalsEng())" : "\(vm.tomanTotalAsDollar().asCurrencyWith2Decimals())")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .font(Font.custom("BYekan+", size: 15)).foregroundColor(Color.theme.SecondaryText)
                                    
                                }
                                
                                Image(systemName: "creditcard.fill")
                            }
                        }
                    }
                }
            }
        }.padding()
//            .frame(width:UIScreen.main.bounds.width * 0.95)
            
            .background(Color.theme.secondaryBg).cornerRadius(15).shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 0, x: 2, y: 2)
//            .padding()
            .ignoresSafeArea()
    }
    
    var cryptoMarketOverview: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.statistic) {stat in
                        StatisticView(stat: stat)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width / 3 ,height: 70 ,alignment: .center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.theme.secondaryBg))
                    .shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 0, x: 2, y: 2)
                    .padding(5)
                    .ignoresSafeArea()
                }
            }
//            .environment(\.layoutDirection, .rightToLeft)
        }
        .frame(width:UIScreen.main.bounds.width * 0.95)
    }
}

//MARK: PREVIEW
struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPrices: .constant(true))
            .environmentObject(dev.homeVM)
        //            .preferredColorScheme(.dark)
    }
}
