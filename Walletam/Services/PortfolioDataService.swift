//
//  PortfolioDataService.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/8/22.
//

import Foundation
import CoreData
import SwiftUI

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortContainer"
    private let entityName: String = "PortEntity"
    private let transactionEntityName: String = "TransEntity"
    
    @Published var savedEntities: [PortEntity] = []
    @Published var irEntities: [IREntity] = []
    @Published var bankEntities: [BankEntity] = []
    
    //MARK: FUTURE
    //    @Published var goldEntities: [GoldEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("⚠️Error loading Core Data! \(error.localizedDescription)")
            }
            self.getPortfolio()
        }
    }
    
    // MARK: GENERAL
    
    //Fetching Data
    func getPortfolio() {
        
        let request = NSFetchRequest<PortEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("⚠️Error fetching Portfolio Entities. \(error.localizedDescription)")
        }
        
        let bankRequest = NSFetchRequest<BankEntity>(entityName: "BankEntity")
        do {
            bankEntities = try container.viewContext.fetch(bankRequest)
        } catch let error {
            print("⚠️Error fetching Bank Entities. \(error.localizedDescription)")
        }
        
        let IRRequest = NSFetchRequest<IREntity>(entityName: "IREntity")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        IRRequest.sortDescriptors = [sort]
        do {
            irEntities = try container.viewContext.fetch(IRRequest)
        } catch let error {
            print("⚠️Error fetching Toman Entities. \(error.localizedDescription)")
        }
        
        //MARK: FUTURE
        //        let goldRequest = NSFetchRequest<GoldEntity>(entityName: "GoldEntity")
        //        do {
        //            goldEntities = try container.viewContext.fetch(goldRequest)
        //        } catch let error {
        //            print("⚠️Error fetching Gold Entities. \(error.localizedDescription)")
        //        }
        
    }
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error {
                print("⚠️Error saving to Core Data. \(error.localizedDescription)")
            }
        }
        
    }
    
    func applyChanges() {
        save()
        self.container.viewContext.refreshAllObjects()
        getPortfolio()
    }
    
    // MARK: CRYPTO
    
    func updatePortfolio(coin: CoinModel, amount: Double, buyPrice: Double, date: Date, note: String) {
        // check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            update(entity: entity, amount: amount, buyPrice: buyPrice, date: date, note: note)
        } else {
            add(coin: coin, amount: amount, buyPrice: buyPrice, date: date, note: note)
        }
    }
    
    private func add(coin: CoinModel, amount: Double, buyPrice: Double, date: Date, note: String) {
        let transEntity = TransEntity(context: container.viewContext)
        let entity = PortEntity(context: container.viewContext)
        entity.coinID = coin.id
        
        transEntity.amount = amount
        transEntity.portfolio = entity
        transEntity.date = date
        transEntity.note = note
        transEntity.buyPrice = buyPrice
        applyChanges()
    }
    
    private func update(entity: PortEntity, amount: Double, buyPrice: Double, date: Date, note: String) {
        let newAmount = TransEntity(context: container.viewContext)
        newAmount.amount = amount
        newAmount.portfolio = entity
        newAmount.date = date
        newAmount.note = note
        newAmount.buyPrice = buyPrice
        applyChanges()
    }
    
    func editCrypto(amount: Double, note: String, buyPrice: Double, date: Date, entity: TransEntity) {
        entity.amount = amount
        entity.note = note
        entity.buyPrice = buyPrice
        entity.date = date
        applyChanges()
    }
    
    func delete(coin: CoinModel) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            container.viewContext.delete(entity)
            applyChanges()
        }
    }
    
    func deleteItem(entity: TransEntity, coin: CoinModel) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    // MARK: TOMAN
    
    func addCustom(amount: Double, date: Date, note: String, bank: String) {
        let entity = IREntity(context: container.viewContext)
        
        entity.amount = amount
        entity.date = date
        entity.note = note
        entity.bank = bankEntities.first(where: { $0.name == bank } )
        applyChanges()
    }
    
    func editToman(amount: Double, date: Date, note: String, entity: IREntity) {
        entity.note = note
        entity.date = date
        entity.amount = amount
        applyChanges()
    }
    
    func deleteIRItem(entity: IREntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    
    func addBank(name: String, code: Double, note: String) {
        let entity = BankEntity(context: container.viewContext)
        
        entity.name = name
        entity.code = code
        entity.note = note
        applyChanges()
    }
    
    func editBank(name: String, code: Double, note: String, entity: BankEntity) {
        entity.name = name
        entity.code = code
        entity.note = note
        applyChanges()
    }
    
    func deleteBankEntity(entity: BankEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    // MARK: GOLD [FUTURE UPDATE]
    
    func addGold(name: String, amount: Double, note: String, date: Date) {
        let entity = GoldEntity(context: container.viewContext)
        
        entity.name = name
        entity.amount = amount
        entity.note = note
        entity.date = date
        applyChanges()
    }
}
