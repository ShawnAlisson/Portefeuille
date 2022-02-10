////
////  PortfolioModel.swift
////  Walletam
////
////  Created by Shayan Alizadeh on 1/18/22.
////
//
//import SwiftUI
//import RealmSwift
//
//
//class PortfolioModel: Object, Identifiable {
//
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var coin: CoinModel
//    @Persisted var amount = RealmSwift.List<Double>()
//    @Persisted var dateAdded: Date = Date()
//    @Persisted var notes: String?
//    @Persisted var favorite: Bool = false
//    @Persisted var category: Category = .nonOraganized
//
//
//}
//
//
//enum Category: String, PersistableEnum {
//    case nonOraganized = "بدون دسته‌بندی"
//    case basisShopping = "خرید روزانه"
//    case restaurant = "کافه و رستوران"
//    case transport = "رفت و آمد"
//    case car = "هزینه‌های خودرو"
//    case fun = "تفریحات"
//    case health = "سلامت"
//    case bill = "قبض و شارژ"
//    case clothes = "پوشاک"
//    case invest = "سرمایه‌گذاری"
//    case savingMoney = "پس‌انداز"
//    case gift = "هدیه"
//    case transfer = "انتقال‌وجه"
//    case addMoney = "افزایش موجودی"
//    case other = "سایر"
//}
