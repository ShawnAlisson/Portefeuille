//
//  Modifier.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/16/22.
//

import Foundation
import SwiftUI

struct PersianTwelveSolo: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("BYekan+", size: 12))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
}

struct PersianFourteenSolo: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom("BYekan+", size: 16))
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }
}

