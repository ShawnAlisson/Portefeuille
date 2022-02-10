//
//  TransactionView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/16/22.
//

import SwiftUI

struct TransactionLoadingView: View {
    
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                TransactionView(coin: coin)
            }
        }
    }
}

struct TransactionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var vm: TransactionViewModel
    @ObservedObject var vmm = HomeViewModel()
//    @State private var refreshingID = UUID()
    @State var showInfoView: Bool = false
    
//    let manage = PortfolioDataService.instance
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: TransactionViewModel(coin: coin))
    }
    
    var body: some View {
        
        VStack {
//            ChartView(coin: vm.coin)
            List {
                Section {
                    ForEach(vm.vm.transList) {item in
                        HStack{
                            if item.amount != 0 {
                                let amountCount = item.amount
                                HStack{
                                    Image(systemName: amountCount > 0 ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                                        .foregroundColor(amountCount > 0 ? Color.theme.green : Color.theme.red)
                                    
                                    VStack{
                                        HStack {
                                            Text("\(item.amount.asCryptoUnlimitedDecimal())")
                                                .font(Font.custom("BYekan+", size: 16))
                                            Text("\(vm.coin.symbol.uppercased())")
                                                .font(.caption).foregroundColor(Color.theme.SecondaryText)
                                        }
                                    }
                                }
                                
                                
                            }
                            
                            Spacer()
                            VStack(alignment: .trailing) {
                                
                                Text("\(item.date?.asShortDateString() ?? "")")
                                    .font(Font.custom("BYekan+", size: 14))
                                Text("\(item.date?.formatted(date: .omitted, time: .shortened) ?? "")")
                                    .font(Font.custom("BYekan+", size: 10))
                                
                            }
                        }
                        
                    }.onDelete(perform: remove)
                }
            header: {
                    
                }
            }
//            .id(refreshingID)
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            //                navigationBarTrailingItem
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Text(vm.coin.symbol.uppercased())
                        .font(.headline)
                    CoinImageView(coin: vm.coin).frame(width: 30, height: 30)
                }
                .background(NavigationLink(
                    destination: PortfolioView(),
                    isActive: $showInfoView,
                    label: { EmptyView() }))
                
            }
        }
    }
    
    //Navigate to Detail View
    private func segue() {
        showInfoView.toggle()
    }
    
    //onDelete Function
    func remove(at offsets: IndexSet) {
        for index in offsets {
            let item = vm.vm.transList[index]
            vm.portfolioDataService.deleteItem(entity: item, coin: vm.coin)
            presentationMode.wrappedValue.dismiss()
//            manage.container.viewContext.reset()
//            self.refreshingID = UUID() // < force refresh
//            manage.container.viewContext.refreshAllObjects()
//            vmm.refreshingID = UUID()
//            vmm.portfolioDataService.container.viewContext.reset()
//            vmm.portfolioDataService.container.viewContext.refreshAllObjects()
            
        }
}
}

//MARK: PREVIEW
struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionView(coin: dev.coin)
        }
    }
}
