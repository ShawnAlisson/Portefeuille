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

//    static let instance = PortfolioDataService()

    private let container: NSPersistentContainer
    private let containerName: String = "PortContainer"
    private let entityName: String = "PortEntity"
    private let transactionEntityName: String = "TransEntity"
    

    @Published var savedEntities: [PortEntity] = []
//    @Published var transactionEntities: [TransEntity] = []
    @Published var irEntities: [IREntity] = []
    @Published var bankEntities: [BankEntity] = []
    @Published var goldEntities: [GoldEntity] = []

    init() {
        container = NSPersistentContainer(name: containerName)
//        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("⚠️Error loading Core Data! \(error.localizedDescription)")
            }
            self.getPortfolio()
        }
    }

    // MARK: PUBLIC

    func updatePortfolio(coin: CoinModel, amount: Double, date: Date) {
        // check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            update(entity: entity, amount: amount, date: date)
        } else {
            add(coin: coin, amount: amount, date: date)
        }
    }

    // MARK: PRIVATE

    func getPortfolio() {
//        let request2 = NSFetchRequest<TransEntity>(entityName: transactionEntityName)
//        let sorter = NSSortDescriptor(key: "date", ascending: false)
//        request2.sortDescriptors = [sorter]
//        do {
//            transactionEntities = try container.viewContext.fetch(request2)
//        } catch let error {
//            print("⚠️Error fetching Portfolio Entities. \(error)")
//        }
        
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
        
        let goldRequest = NSFetchRequest<GoldEntity>(entityName: "GoldEntity")
        do {
            goldEntities = try container.viewContext.fetch(goldRequest)
        } catch let error {
            print("⚠️Error fetching Gold Entities. \(error.localizedDescription)")
        }
        
        let IRRequest = NSFetchRequest<IREntity>(entityName: "IREntity")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        IRRequest.sortDescriptors = [sort]
        do {
            irEntities = try container.viewContext.fetch(IRRequest)
        } catch let error {
            print("⚠️Error fetching Toman Entities. \(error.localizedDescription)")
        }
        
    }
    
    func addCustom(amount: Double, date: Date, note: String, bank: String) {
        let entity = IREntity(context: container.viewContext)
        
        entity.amount = amount
        entity.date = date
        entity.note = note
        entity.bank = bankEntities.first(where: { $0.name == bank } )
        applyChanges()
    }
    
    func addBank(name: String, code: Double, note: String) {
        let entity = BankEntity(context: container.viewContext)
        
        entity.name = name
        entity.code = code
        entity.note = note
//        entity.color = color
        applyChanges()
    }
    
    func addGold(name: String, amount: Double, note: String, date: Date) {
        let entity = GoldEntity(context: container.viewContext)
        
        entity.name = name
        entity.amount = amount
        entity.note = note
        entity.date = date
        applyChanges()
    }

    private func add(coin: CoinModel, amount: Double, date: Date) {
        
        let transEntity = TransEntity(context: container.viewContext)
        let entity = PortEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.change = false
        
        transEntity.amount = amount
        transEntity.portfolio = entity
        transEntity.date = date
        applyChanges()
    }

    private func update(entity: PortEntity, amount: Double, date: Date) {

        let newAmount = TransEntity(context: container.viewContext)
        newAmount.amount = amount
        newAmount.portfolio = entity
        newAmount.date = date
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
    
    func deleteIRItem(entity: IREntity) {
        
        container.viewContext.delete(entity)
        applyChanges()
        
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
}
