//
//  DetailViewModel.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/14/22.
//

import Foundation
import Combine
import SwiftUI

class DetailViewModel: ObservableObject {
    
    @Published var overviewStats: [StatisticModel] = []
    @Published var additionalStats: [StatisticModel] = []
    @Published var changeIn24hStats: [StatisticModel] = []
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    @Published var githubURL: String? = nil
    @Published var telegramURL: String? = nil
   
    @Published var coin: CoinModel
    
    @ObservedObject var vm = HomeViewModel()
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
   
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self] (returnedCoinDetails) in
                self?.overviewStats = returnedCoinDetails.overview
                self?.changeIn24hStats = returnedCoinDetails.changeIn24h
                self?.additionalStats = returnedCoinDetails.additional

            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] (returnedDetails) in
                self?.websiteURL = returnedDetails?.links?.homepage?.first
                self?.redditURL = returnedDetails?.links?.subredditURL
                self?.githubURL = returnedDetails?.links?.reposURL?.github?.first
                self?.telegramURL = returnedDetails?.links?.telegramChannelIdentifier
                //self?.coinFaID = returnedDetails?.localization?.ar
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistic(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel], changeIn24h: [StatisticModel]) {
        
        //MARK: Overview Infos
        let price = (vm.translateState ? (coinModel.currentPrice.asCurrencyWith6DecimalsENG()) : (coinModel.currentPrice.asCurrencyWith6Decimals()) )
        let pricePerChange = coinModel.priceChangePercentage24H
        let priceStats = StatisticModel(title: vm.translateState ? "Price" : "قیمت", value: price, percentageChange: pricePerChange)
        
        let marketCap =  (vm.translateState ? (coinModel.marketCap?.formattedWithAbbreviationsEng() ?? "") : (coinModel.marketCap?.formattedWithAbbreviations() ?? ""))
        let marketCapPerChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: vm.translateState ? "Market Volume" : "حجم بازار", value: marketCap, percentageChange: marketCapPerChange)
        
        let rank = "\(coinModel.rank)"
        let rankStats = StatisticModel(title: vm.translateState ? "Rank" : "رتبه", value: rank)
    
        
        let volume = (vm.translateState ?  (coinModel.totalVolume?.formattedWithAbbreviationsEng() ?? "-") : (coinModel.totalVolume?.formattedWithAbbreviations() ?? "-") )
        let volumeStats = StatisticModel(title: vm.translateState ? "24h Trades" : "معاملات ۲۴ ساعت", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStats, marketCapStat, rankStats, volumeStats
        ]
        
        //MARK: 24h Infos
        let high = (vm.translateState ? (coinModel.high24H?.asCurrencyWith6DecimalsENG() ?? "-") : (coinModel.high24H?.asCurrencyWith6Decimals() ?? "-") )
        let highStats = StatisticModel(title: vm.translateState ? "Highest Price" : "بالاترین قیمت", value: high)
        
        let low = (vm.translateState ? (coinModel.low24H?.asCurrencyWith6DecimalsENG() ?? "-"):(coinModel.low24H?.asCurrencyWith6Decimals() ?? "-"))
        
        let lowStats = StatisticModel(title: vm.translateState ? "Lowest Price" : "پایین‌ترین قیمت", value: low)
        
        let priceChange = (vm.translateState ? (coinModel.priceChange24H?.asCurrencyWith6DecimalsENG() ?? "-"):(coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "-"))
        
        let pricePerChange2 = coinModel.priceChangePercentage24H
        let priceChangeStats = StatisticModel(title: vm.translateState ? "Price Changes" : "تغییرات قیمت", value: priceChange, percentageChange: pricePerChange2)
        
       
        let marketCapChange = (vm.translateState ? (coinModel.marketCapChange24H?.formattedWithAbbreviationsEng() ?? "-") : (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "-"))
        let marketCapPerChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStats = StatisticModel(title: vm.translateState ? "Market Volume Changes" : "تفییرات حجم بازار", value: marketCapChange, percentageChange: marketCapPerChange2)
        
        let chnageIn24HArray: [StatisticModel] = [
            highStats, lowStats, priceChangeStats, marketCapChangeStats
            ]
        
        //MARK: Footer Infos
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeStats = StatisticModel(title: vm.translateState ? "‌Block Build Time" : "زمان ساخته شدن بلاک", value: vm.translateState ? blockTime.asIntToEngString() : blockTime.engToFaInt())
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "-"
        let hashingStats = StatisticModel(title: vm.translateState ? "Hash Algorithm" : "هش الگوریتم", value: hashing)
        
        let genesisDate = coinDetailModel?.genesisDate ?? "-"
        let genesisDateStats = StatisticModel(title: vm.translateState ? "Created" : "زمان پیدایش", value: vm.translateState ? (genesisDate.toDate()?.asShortDateStringENG() ?? "-") : (genesisDate.toDate()?.asShortDateString() ?? "-") )
        
        let additionalArray: [StatisticModel] = [
            blockTimeStats, hashingStats, genesisDateStats
        ]
        
        return (overviewArray,additionalArray, chnageIn24HArray)
    }
}

