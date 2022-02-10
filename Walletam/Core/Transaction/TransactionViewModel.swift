//
//  TransactionViewModel.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/17/22.
//

import Foundation
import Combine
import SwiftUI

class TransactionViewModel: ObservableObject {
    
     var coin: CoinModel
    
    let sorter = NSSortDescriptor(key: "date", ascending: false)
    
    let portfolioDataService: PortfolioDataService
    @ObservedObject var vm = HomeViewModel()
//   @Published var entity: PortEntity?

    init(coin: CoinModel) {
        self.coin = coin
        self.portfolioDataService = PortfolioDataService()
//        self.entity = portfolioDataService.savedEntities.first(where: { $0.coinID == coin.id })
        self.vm.transList = portfolioDataService.savedEntities.first(where: { $0.coinID == coin.id })?.transactions?.allObjects as? [TransEntity] ?? []
        self.vm.transList = self.vm.transList.sorted(by: {$0.date! > $1.date!})
        
    }
    
    
//    private func addSubscribers() {
//
//        portfolioDataService.$transactionEntities
//            .combineLatest($coin)
//            .sink { [weak self] (returnedCoinDetails) in
//                self?.transList = returnedCoinDetails
//            }
//            .store(in: &cancellables)
//
//
//
//    }
}
