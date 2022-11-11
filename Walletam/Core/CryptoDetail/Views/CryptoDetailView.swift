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
                CryptoDetailView(coin: coin)
            }
        }
    }
}

struct CryptoDetailView: View {
    
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

//MARK: EXTENSIONS
extension CryptoDetailView {
    
    //MARK: Overview
    private var overviewTitle: some View {
        CoinImageView(coin: vm.coin)
            .frame(width: 60, height: 60, alignment: .center)
            .shadow(color: Color.theme.shadowColor.opacity(0.4), radius: 5, x: 0, y: 0)
    }
    
    //MARK: 24h
    private var changeIn24hTitle: some View {
        Text("24h_changes")
            .font(Font.custom("BYekan+", size: 18))
            .foregroundColor(Color.accentColor)
            .frame(maxWidth: .infinity, alignment: .center)
        
    }
    
    //MARK: Overview Gride
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
    
    //MARK: 24h Gride
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
    
    //MARK: Additional Gride
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
    
    //MARK: Social Links
    private var socialLinks: some View {
        SocialLinksView(websiteURL: vm.websiteURL, githubURL: vm.githubURL, redditURL: vm.redditURL, telegramURL: vm.telegramURL, twitterURL: nil)
    }
}

//MARK: PREVIEW
struct CryptoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CryptoDetailView(coin: dev.coin)
                
        }
        
        //.preferredColorScheme(.dark)
    }
}
