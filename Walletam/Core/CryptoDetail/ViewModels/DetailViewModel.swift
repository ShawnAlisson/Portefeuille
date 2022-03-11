//
//  DetailViewModel.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/14/22.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStats: [StatisticModel] = []
    @Published var additionalStats: [StatisticModel] = []
    @Published var changeIn24hStats: [StatisticModel] = []
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    @Published var githubURL: String? = nil
    @Published var telegramURL: String? = nil
   
    @Published var coin: CoinModel
    
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
        // overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePerChange = coinModel.priceChangePercentage24H
        let priceStats = StatisticModel(title: "قیمت", value: price, percentageChange: pricePerChange)
        
        let marketCap = coinModel.marketCap?.formattedWithAbbreviations() ?? ""
        let marketCapPerChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "حجم بازار", value: marketCap, percentageChange: marketCapPerChange)
        
        let rank = "\(coinModel.rank)"
        let rankStats = StatisticModel(title: "رتبه", value: rank)
    
        let volume = coinModel.totalVolume?.formattedWithAbbreviations() ?? "-"
        let volumeStats = StatisticModel(title: "معاملات ۲۴ ساعت", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStats, marketCapStat, rankStats, volumeStats
        ]
        
        //24h change
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "-"
        let highStats = StatisticModel(title: "بالاترین قیمت", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "-"
        let lowStats = StatisticModel(title: "پایین‌ترین قیمت", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "-"
        let pricePerChange2 = coinModel.priceChangePercentage24H
        let priceChangeStats = StatisticModel(title: "تغییر قیمت", value: priceChange, percentageChange: pricePerChange2)
        
        let marketCapChange = coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "-"
        let marketCapPerChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStats = StatisticModel(title: "تغییر حجم بازار", value: marketCapChange, percentageChange: marketCapPerChange2)
        
        let chnageIn24HArray: [StatisticModel] = [
            highStats, lowStats, priceChangeStats, marketCapChangeStats
            ]
        
        //aditional
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "-" : "\(blockTime.engToFaInt())"
        let blockTimeStats = StatisticModel(title: "زمان ساخت بلاک", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "-"
        let hashingStats = StatisticModel(title: "الگوریتم هش", value: hashing)
        
        let genesisDate = coinDetailModel?.genesisDate ?? "-"
        let genesisDateStats = StatisticModel(title: "تاریخ پیدایش", value: (genesisDate.toDate()?.asShortDateString()) ?? "-" )
        
        let additionalArray: [StatisticModel] = [
            blockTimeStats, hashingStats, genesisDateStats
        ]
        
        return (overviewArray,additionalArray, chnageIn24HArray)
    }
}

