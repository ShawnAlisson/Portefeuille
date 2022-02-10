//
//  CustomCoinModel.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/27/22.
//

import Foundation

struct CustomCoinModel: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let value: Double
    
}
