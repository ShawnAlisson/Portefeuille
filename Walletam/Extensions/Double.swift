//
//  Double.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/5/22.
//

import Foundation

extension Double {
    
    private var  creaditCardFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 4
        formatter.groupingSeparator = "    "
        formatter.locale = Locale(identifier: "fa_IR")
        //formatter.currencyCode = "usd
        return formatter
    }
    
    //converts double to currency with 2 decimal places
    private var  currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "fa_IR")
      //  formatter.currencyCode = "usd"
       formatter.currencySymbol = "$"
        formatter
            .minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    private var  tomanFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "fa_IR")
      //  formatter.currencyCode = "usd"
       formatter.currencySymbol = ""
        formatter
            .minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    //converts double to currency with 0-6 decimal places
    private var  currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "fa_IR")
        //formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter
            .minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    private var  tomanFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "fa_IR")
        //formatter.currencyCode = "usd"
        formatter.currencySymbol = ""
        formatter
            .minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    private var  currencyFormatter6ENG: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        //formatter.numberStyle = .currency
       formatter.locale = Locale(identifier: "en_US")
//        formatter.currencySymbol = "$"
        formatter
            .minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    private var cryptoFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        //formatter.numberStyle = .currency
       formatter.locale = Locale(identifier: "fa_IR")
        formatter.currencySymbol = ""
        formatter
            .minimumFractionDigits = 0
       formatter.maximumFractionDigits = 10
        return formatter
    }
    
    
    //converts currency to string with 2 decimal places
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return (currencyFormatter2.string(from: number) ?? "")
    }
    func asTomanWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return (tomanFormatter2.string(from: number) ?? "")
    }
    
    //converts currency to string with 2-6 decimal places
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return (currencyFormatter6.string(from: number) ?? "$0.00")
    }
    
    func asTomanWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return (tomanFormatter6.string(from: number) ?? "")
    }
    
    func asCurrencyWith6DecimalsENG() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6ENG.string(from: number) ?? "$0.00"
    }
    
    func asCryptoUnlimitedDecimal() -> String {
        let number = NSNumber(value: self)
        return cryptoFormatter.string(from: number) ?? ""
    }
    
    
    func asNumberString() -> String {
        return String(format: "%.2f", locale: Locale(identifier: "fa_IR"), self)
    }
    
    func asEngNumberString() -> String {
        return String(format: "%.0f", self)
    }
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    func asCreaditCardString() -> String {
        let number = NSNumber(value: self)
        return creaditCardFormatter.string(from: number) ?? ""
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
        /// ```
        /// Convert 12 to 12.00
        /// Convert 1234 to 1.23K
        /// Convert 123456 to 123.45K
        /// Convert 12345678 to 12.34M
        /// Convert 1234567890 to 1.23Bn
        /// Convert 123456789012 to 123.45Bn
        /// Convert 12345678901234 to 12.34Tr
        /// ```
        func formattedWithAbbreviations() -> String {
            let num = abs(Double(self))
            let sign = (self < 0) ? "-" : ""

            switch num {
            case 1_000_000_000_000...:
                let formatted = num / 1_000_000_000_000
                let stringFormatted = formatted.asNumberString()
                return "\(sign)\(stringFormatted) تریلیون"
            case 1_000_000_000...:
                let formatted = num / 1_000_000_000
                let stringFormatted = formatted.asNumberString()
                return "\(sign)\(stringFormatted) میلیارد"
            case 1_000_000...:
                let formatted = num / 1_000_000
                let stringFormatted = formatted.asNumberString()
                return "\(sign)\(stringFormatted) میلیون"
            case 1_000...:
                let formatted = num / 1_000
                let stringFormatted = formatted.asNumberString()
                return "\(sign)\(stringFormatted) هزار"
            case 0...:
                return self.asNumberString()

            default:
                return "\(sign)\(self)"
            }
        }

        
    }



extension Int {
    
    private var  intFaFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "fa_IR")
        return formatter
    }
    
    func engToFaInt() -> String {
        let number = NSNumber(value: self)
        return intFaFormatter.string(from: number) ?? "-"
    }
    
}
