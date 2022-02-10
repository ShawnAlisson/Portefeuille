//
//  UIApplication.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/7/22.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
