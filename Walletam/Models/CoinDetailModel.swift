//
//  CoinDetailModel.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/14/22.
//

import Foundation

// JSON Data
/*
 URL: https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
 */

struct CoinDetailModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let links: Links?
    let genesisDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case genesisDate = "genesis_date"
    }
}

struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    let telegramChannelIdentifier: String?
    let reposURL: ReposURL?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case reposURL = "repos_url"
        case subredditURL = "subreddit_url"
        case telegramChannelIdentifier = "telegram_channel_identifier"
    }
}

struct ReposURL: Codable {
    let github: [String]?
}

