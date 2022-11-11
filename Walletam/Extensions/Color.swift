//
//  Color.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/5/22.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    static let card = CardColor()
    
}

struct CardColor {
    let blue = Color("blueCard")
    let aqua = Color("aquaCard")
    let purple = Color("purpleCard")
    let red = Color("redCard")
    let grey = Color("greyCard")
    let yellow = Color("yellowCard")
    let orange = Color("orangeCard")
    let green = Color("greenCard")
}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let secondaryBg = Color("SecondaryBackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let shadowColor = Color("ShadowColor")
    let SecondaryText = Color("SecondaryTextColor")
    let tgBlue = Color("TGBlue")
    let reverseBackgroundColor = Color("ReverseBackgroundColor")
    let bwColor = Color("BW")
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
