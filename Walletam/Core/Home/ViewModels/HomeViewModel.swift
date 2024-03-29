//
//  HomeViewModel.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/5/22.
//

import Foundation
import Combine
import Network
import SwiftUI

class HomeViewModel: ObservableObject {

    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var statistic: [StatisticModel] = []
    @Published var tethStatsPrice: [StatisticModel] = []
    
    @Published var sortOptions: SortOption = .holding
    
    enum SortOption {
        case rank, rankReversed, holding, holdingReversed, price, priceReversed, percentage, percentageReversed
    }
    
    @ObservedObject var monitor = NetworkMonitor()
    

    //MARK: App Storage
    @AppStorage("currencyChange") var showCurrencyChange: Bool = false
    @AppStorage("authState") var authState: Bool = false
    @AppStorage("translateState") var translateState: Bool = false
//    @AppStorage("calendarState") var calendarState: Bool = false
    
    
    @Published var tethPrice: String? = nil
    @Published var searchField: String = ""
    @Published var isLoading: Bool = false
    @Published var transList: [TransEntity] = []
    @Published var irPrice: Double? = nil
    
    @Published var dateAdded: Date = Date.now
    
    private var cancellables = Set<AnyCancellable>()
    
    private let dataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let tethDataService = TethDataService()
    let portfolioDataService = PortfolioDataService()
    
    
   
    
    init() {
        addSubscriber()
        irAmountCalc()
        isLoading = true
        }
    
    func addSubscriber() {
        
        //update all coins
        $searchField
            .combineLatest(dataService.$allCoins, $sortOptions)
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main)
            .map(fiterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins}
            .store(in: &cancellables)
        
        //update portfolio
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapToPortfolioCoins)
            .sink { [ weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinIfNeeded(coins: returnedCoins)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isLoading = false
                }
            }
            .store(in: &cancellables)
        
        
        //update market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistic = returnedStats
            }
            .store(in: &cancellables)
        
        
        //get tether price
        tethDataService.$tethPrice
            .sink { [weak self] (returnedPrice) in
                self?.tethPrice = returnedPrice?.asks?.first?.first ?? ""
            }
            .store(in: &cancellables)
            
        
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double, buyPrice: Double, date: Date, note: String) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount, buyPrice: buyPrice, date: dateAdded, note: note)
    }
    
    func reloadData() {
        isLoading = true
        dataService.getCoins()
        marketDataService.getData()
        tethDataService.getTethPrice()
        portfolioDataService.getPortfolio()
        
    }
    
    private func fiterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        
        var filteredCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &filteredCoins)
        return filteredCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        
        switch sort {
        case .rank, .holding:
            coins.sort(by: {$0.rank < $1.rank })
        case .rankReversed, .holdingReversed:
            coins.sort(by: {$0.rank > $1.rank })
        case .price:
            coins.sort(by: {$0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: {$0.currentPrice < $1.currentPrice })
        case .percentage:
            coins.sort(by: {$0.priceChangePercentage24H ?? 0 > $1.priceChangePercentage24H ?? 0})
        case .percentageReversed:
            coins.sort(by: {$0.priceChangePercentage24H ?? 0 < $1.priceChangePercentage24H ?? 0})
        }
    }
    
    private func sortPortfolioCoinIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        
        switch sortOptions {
        case .holding:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func mapToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }), let newTrans = entity.transactions?.allObjects as? [TransEntity] else {
                    return nil
                }
                let newValue = newTrans.map { $0.amount }.reduce(0, +)
                return coin.updateHoldings(amount: newValue)
                
            }
        
    }
    
    func irAmountCalc() {
        
        let entity = portfolioDataService.irEntities as [IREntity]
        let newValue = entity.map { $0.amount }.reduce(0, +)
        return irPrice = newValue
    }
    
    
    
     func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        //MARK: Stats Info
         let marketCap = StatisticModel(title: translateState ? "Total Market Value" : "حجم کلی بازار", value: translateState ? (data.marketCap.formattedWithAbbreviationsEng()) : (data.marketCap.formattedWithAbbreviations()), percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: translateState ? "24h Trades" : "معاملات ۲۴ ساعت", value: translateState ? (data.volume.formattedWithAbbreviationsEng()) : (data.volume.formattedWithAbbreviations()))
        let btcDom = StatisticModel(title: translateState ? "BTC Dominance" : "سهم بیت‌کوین" , value: translateState ? (data.btcDominance.asPercentStringENG()) : (data.btcDominance.asPercentString()))
        
        let newTethPrice = ((tethPrice ?? "") as NSString).doubleValue
         let tethStatsPrice = StatisticModel(title: translateState ? "USDT Price" : "قیمت دلار", value: translateState ? ((newTethPrice / 10).asCurrencyWith2DecimalsENG()):((newTethPrice / 10).asTomanWith2Decimals()))
        
        let portfolioCryptoValue =
            portfolioCoins
                .map({ $0.currentHoldingsValue })
        //sum of all [double] to double
                .reduce(0, +)
         
         let portfolioValue = portfolioCryptoValue + ((irPrice ?? 0) / newTethPrice * 10)
        
        let previousValue =
            portfolioCoins
                .map { (coin) -> Double in
                     let currentValue = coin.currentHoldingsValue
                     let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                     let previousValue = currentValue / (1 + percentChange)
                     return previousValue
                }
                .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let newPercentageChange: Double
        
        if percentageChange.isNaN {
            newPercentageChange = 0
        } else {
            newPercentageChange = percentageChange
        }

         let portfolio = StatisticModel(title: translateState ? "Assets in Dollar" : "دارایی به دلار", value: translateState ? (portfolioValue.asCurrencyWith2DecimalsENG()):(portfolioValue.asCurrencyWith2Decimals()),
                                       percentageChange: newPercentageChange)
        
         let irPortfolio =  StatisticModel(title: translateState ? "Assets in TMN" : "دارایی به تومان", value: translateState ? ((portfolioValue * newTethPrice / 10).asCurrencyWith2DecimalsENG()):((portfolioValue * newTethPrice / 10).asTomanWith2Decimals()))
        
        
        
        stats.append(contentsOf: [
            irPortfolio,
            portfolio,
            tethStatsPrice,
            btcDom,
            volume,
            marketCap,
        ])
        return stats
    }
    
    func tethPriceAsDouble() -> Double {
        let newPrice = ((tethPrice ?? "") as NSString).doubleValue
        return newPrice
    }
    
    func cryptoTotalCalc() -> Double {
        let portfolioCryptoValue =
            portfolioCoins
                .map({ $0.currentHoldingsValue })
        //sum of all [double] to double
                .reduce(0, +)
        return portfolioCryptoValue
    }
    
    func cryptoTotalAsToman() -> Double {
        let newPrice = cryptoTotalCalc() * tethPriceAsDouble() / 10
        return newPrice
    }
    
    func tomanTotalAsDollar() -> Double {
        let newPrice = (irPrice ?? 0) / tethPriceAsDouble() * 10
        return newPrice
    }
    
    func totalPortfolioCalc() -> Double {
        let newTethPrice = ((tethPrice ?? "") as NSString).doubleValue
        let portfolioCryptoValue =
            portfolioCoins
                .map({ $0.currentHoldingsValue })
        //sum of all [double] to double
                .reduce(0, +)
         
         let portfolioValue = portfolioCryptoValue + ((irPrice ?? 0) / newTethPrice * 10)
        return portfolioValue
    }
    
    func totalPortfolioToman() -> Double {
        let value = totalPortfolioCalc() * tethPriceAsDouble() / 10
        return value
    }
    }




    

