//
//  Date.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/14/22.
//

import Foundation

extension Date {
    
    // "2021-03-13T20:49:26.606Z"
    init(coinGeckoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.calendar = Calendar(identifier: .persian)
        formatter.locale = Locale(identifier: "fa_IR")
        return formatter
    }
    
    private var persianTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.locale = Locale(identifier: "fa_IR")
        formatter.calendar = Calendar(identifier: .persian)
        return formatter
//        formatted(date: .omitted, time: .shortened)
    }
    
    func asPersianTimeString() -> String {
        return persianTimeFormatter.string(from: self)
    }
    
    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
    
}


extension String {
    public enum DateFormatType {
        
        case isoDate
        
        var stringFormat:String {
            switch self {
                
            case .isoDate: return "yyyy-MM-dd"
            }
        }
    }
    
    func toDate(_ format: DateFormatType = .isoDate) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        return date
    }
}
