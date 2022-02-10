//
//  TethDataService.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/15/22.
//

import Foundation
import Combine

class TethDataService {

    @Published var tethPrice: TethModel? = nil

    var tethSub: AnyCancellable?

    init() {
        getTethPrice()
    }

     func getTethPrice() {

        guard let url = URL(string: "https://api.nobitex.ir/v2/orderbook/USDTIRT") else { return }

        tethSub = NetworkingManager.download(url: url)
            .decode(type: TethModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedTethPrice) in
                self?.tethPrice = returnedTethPrice
                self?.tethSub?.cancel()
            })
                  }
                  }
