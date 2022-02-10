//
//  TethModel.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/15/22.
//

import Foundation

struct TethModel: Codable {
    let status: String?
    let bids: [[String]]?
    let asks: [[String]]?
}
