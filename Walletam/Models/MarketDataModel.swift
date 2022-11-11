//
//  MarketDataModel.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/7/22.
//

import Foundation

// JSON data:
/*
 URL: https://api.coingecko.com/api/v3/global
 */

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: Double {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return item.value
        }
        return 0
    }
    
    var volume: Double {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return item.value
        }
        return 0
    }
    
    var btcDominance: Double {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value
        }
        return 0
    }
}


