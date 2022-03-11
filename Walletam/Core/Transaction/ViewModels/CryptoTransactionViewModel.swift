//
//  TransactionViewModel.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/17/22.
//

import Foundation
import Combine
import SwiftUI

class CryptoTransactionViewModel: ObservableObject {
    
     var coin: CoinModel
    
    let sorter = NSSortDescriptor(key: "date", ascending: false)
    
    let portfolioDataService: PortfolioDataService
    @ObservedObject var vm = HomeViewModel()

    init(coin: CoinModel) {
        self.coin = coin
        self.portfolioDataService = PortfolioDataService()
        self.vm.transList = portfolioDataService.savedEntities.first(where: { $0.coinID == coin.id })?.transactions?.allObjects as? [TransEntity] ?? []
        self.vm.transList = self.vm.transList.sorted(by: {$0.date! > $1.date!})
    }
}
