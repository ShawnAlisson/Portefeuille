//
//  DetailView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/14/22.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    
    private let twoColumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let threeColumns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                ChartView(coin: vm.coin)
                overviewTitle
                overviewGride
                changeIn24hTitle
                changeIn24hGride
                socialLinks
                Divider()
                additionalGride
               
                
            }
            .navigationTitle(vm.coin.name)
            .toolbar {
//                navigationBarTrailingItem
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack{
                        Text(vm.coin.symbol.uppercased())
                            .font(.headline)
                        CoinImageView(coin: vm.coin).frame(width: 30, height: 30)
                        
                    }
                }
            }
        }
        
    }
}


//MARK: PREVIEW
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
        //.preferredColorScheme(.dark)
    }
}

extension DetailView {
    
    private var overviewTitle: some View {
        
        CoinImageView(coin: vm.coin)
            .frame(width: 60, height: 60, alignment: .center)
            .shadow(color: Color.theme.shadowColor.opacity(0.4), radius: 5, x: 0, y: 0)
//        Text("اطلاعات کلی")
//            .font(Font.custom("BYekan+", size: 18))
//            .foregroundColor(Color.accentColor)
//            .frame(maxWidth: .infinity, alignment: .center)
//            //.padding(.horizontal)
    }
    private var changeIn24hTitle: some View {
        Text("تغییرات ۲۴ ساعت اخیر")
            .font(Font.custom("BYekan+", size: 18))
            .foregroundColor(Color.accentColor)
            .frame(maxWidth: .infinity, alignment: .center)
            //.padding(.horizontal)
    }
    
    private var overviewGride: some View {
        LazyVGrid(columns: twoColumns,
                  alignment: .center,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.overviewStats) {stats in
                StatisticView(stat: stats)
            }
        }
                  .padding()
                  .background(
                    .ultraThinMaterial).cornerRadius(15)
                    .shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 10, x: 0, y: 0)
                  .padding()
        
        
    }
    
    private var changeIn24hGride: some View {
        LazyVGrid(columns: twoColumns,
                  alignment: .center,
                  spacing: spacing,
                  pinnedViews: []) {
            ForEach(vm.changeIn24hStats) {stats in
                StatisticView(stat: stats)
            }
        }
                  .padding()
                  .background(
                    .ultraThinMaterial).cornerRadius(15)
                    .shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 10, x: 0, y: 0)
                  .padding()
        
    }
    
    private var additionalGride: some View {
        LazyVGrid(columns: threeColumns,
                  alignment: .center,
                  spacing: nil,
                  pinnedViews: []) {
            ForEach(vm.additionalStats) {stats in
                StatisticView(stat: stats)
            }
        }
        
    }
    
    private var socialLinks: some View {
        HStack(spacing: 25) {
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString) {
                Link(destination: url) {
                    Image(systemName: "globe.asia.australia.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.blue)
                        .frame(width: 30, height: 30)
                }
            }
            if let githubString = vm.githubURL,
               let url = URL(string: githubString) {
                Link(destination: url) {
                    Image("github")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 31, height: 31)
                }
            }
            
            if let redditString = vm.redditURL,
               let url = URL(string: redditString) {
                Link(destination: url) {
                    Image("reddit")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.theme.tgBlue)
                        .frame(width: 31, height: 31)
                }
            }
                
            
            
            if let telegramString = vm.telegramURL,
               let url = URL(string: "https://t.me/\(telegramString)") {
                Link(destination: url) {
                    Image(systemName: "paperplane.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.theme.tgBlue)
                        .frame(width: 31, height: 31)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 10, x: 0, y: 0)
        .padding()
    }
}
