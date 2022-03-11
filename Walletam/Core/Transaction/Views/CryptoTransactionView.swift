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
                CryptoTransactionView(coin: coin)
            }
        }
    }
}

struct CryptoTransactionView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var vm: CryptoTransactionViewModel
    
    @ObservedObject var vmm = HomeViewModel()
    
    @State var showInfoView: Bool = false
    @State var showTransactionDetailView: Bool = false
    @State private var selectedTran: TransEntity? = nil
    @State private var showEditView: Bool = false
    
    @State private var amountText: String = ""
    @State private var buyPriceText: String = ""
    @State private var noteText: String = ""
    
    
    @FocusState private var amountIsFocused: Bool
    @FocusState private var buyPriceIsFocused: Bool
    @FocusState private var noteIsFocused: Bool
    
    
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CryptoTransactionViewModel(coin: coin))
    }
    
    var body: some View {
        VStack {
            ChartView(coin: vm.coin)
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
                        .background(Color.theme.background.opacity(0.001))
                        .onTapGesture {
                            tranSegue(tran: item)
                        }
                    }
                    .onDelete(perform: remove)
                }
            }
        }
        .sheet(isPresented: $showTransactionDetailView, content: {
            transactionDetailView
        })
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack{
                    Text(vm.coin.symbol.uppercased())
                        .font(.headline)
                    CoinImageView(coin: vm.coin).frame(width: 30, height: 30)
                }
                .background(NavigationLink(
                    destination: ManagePortfolioView(),
                    isActive: $showInfoView,
                    label: { EmptyView() }))
            }
        }
    }
}

//MARK: EXTENSION
extension CryptoTransactionView{
    
    //MARK: VIEWS
    private var transactionDetailView: some View {
        ZStack {
            List {
                Section {
                    HStack {
                        if showEditView {
                            HStack {
                                TextField("", text: $amountText)
                                    .focused($amountIsFocused)
                                    .multilineTextAlignment(.leading)
                                    .font(Font.custom("BYekan", size: 14))
                                    .padding(10)
                                    .background(.ultraThinMaterial).cornerRadius(10)
                                    .onTapGesture {
                                        amountIsFocused = true
                                    }
                                    .onAppear { self.amountText = selectedTran?.amount.asEngNumberString() ?? "" }
                            }
                        } else {
                            HStack(spacing: 5) {
                                Text("\(selectedTran?.amount.asTomanWith2Decimals() ?? "-")").font(Font.custom("BYekan+", size: 14))
                            }
                        }
                        
                        Spacer()
                        Text("مقدار:").font(Font.custom("BYekan+", size: 16))
                    }
                    .padding(.horizontal)
                    
                    HStack{
                        if showEditView {
                            HStack {
                                TextField("", text: $buyPriceText)
                                    .focused($buyPriceIsFocused)
                                    .multilineTextAlignment(.leading)
                                    .font(Font.custom("BYekan", size: 14))
                                    .padding(10)
                                    .background(.ultraThinMaterial).cornerRadius(10)
                                    .onTapGesture {
                                        buyPriceIsFocused = true
                                    }
                                    .onAppear { self.buyPriceText = selectedTran?.buyPrice.asEngNumberString() ?? "" }
                            }
                        } else {
                            Text("\(selectedTran?.buyPrice ?? 0 )").font(Font.custom("BYekan+", size: 14))
                        }
                        Spacer()
                        Text(((selectedTran?.amount ?? 0) > 0) ? "قیمت خرید:" : "قیمت فروش").font(Font.custom("BYekan+", size: 16))
                    }.padding(.horizontal)
                    
                    HStack{
                        Text("\((selectedTran?.buyPrice ?? 0) * (selectedTran?.amount ?? 0))").font(Font.custom("BYekan+", size: 14))
                        Spacer()
                        Text(((selectedTran?.amount ?? 0) > 0) ? "ارزش زمان خرید:" : "ارزش زمان فروش:").font(Font.custom("BYekan+", size: 16))
                    }.padding(.horizontal)
                    
                    
                    if showEditView {
                        HStack {
                            HStack {
                                DatePicker(selection: $vmm.dateAdded , label: { Text("تاریخ و ساعت:")})
                                    .font(Font.custom("BYekan+", size: 16))
                                    .datePickerStyle(.compact)
                                    .environment(\.locale, Locale.init(identifier: "fa_IR"))
                                    .environment(\.calendar,Calendar(identifier: .persian))
                                    .environment(\.layoutDirection, .rightToLeft)
                                    .padding(.horizontal)
                            }
                            .onAppear { self.vmm.dateAdded = selectedTran?.date ?? Date.now }
                        }
                    } else {
                        HStack{
                            Text("\(selectedTran?.date?.asShortDateString() ?? "")").font(Font.custom("BYekan+", size: 14))
                            Spacer()
                            Text("تاریخ:").font(Font.custom("BYekan+", size: 16))
                        }.padding(.horizontal)
                        
                        HStack{
                            Text("\(selectedTran?.date?.asPersianTimeString() ?? "")").font(Font.custom("BYekan+", size: 14))
                            Spacer()
                            Text("ساعت:").font(Font.custom("BYekan+", size: 16))
                        }.padding(.horizontal)
                    }
                    
                    
                    VStack(alignment: .trailing) {
                        HStack{
                            Spacer()
                            Text("یادداشت:").font(Font.custom("BYekan+", size: 16))
                        }
                        if showEditView {
                            HStack {
                                TextField("", text: $noteText)
                                    .focused($noteIsFocused)
                                    .multilineTextAlignment(.leading)
                                    .font(Font.custom("BYekan", size: 14))
                                    .padding(10)
                                    .background(.ultraThinMaterial).cornerRadius(10)
                                    .onTapGesture {
                                        noteIsFocused = true
                                    }
                                    .onAppear { self.noteText = selectedTran?.note ?? "" }
                            }
                        } else {
                            
                            Text("\(selectedTran?.note ?? "")").font(Font.custom("BYekan+", size: 16))
                                .multilineTextAlignment(.trailing)
                        }
                        
                    }
                    .padding(.horizontal)
                }
            header: {
                
                Image(systemName: showEditView ? "checkmark" : "pencil")
                    .font(.title)
                    .padding()
                    .onTapGesture {
                        if showEditView {
                            vm.portfolioDataService.editCrypto(amount: Double(amountText) ?? 0, note: noteText, buyPrice: Double(buyPriceText) ?? 0, date: vmm.dateAdded, entity: selectedTran!)
                            showEditView.toggle()
                        } else {
                            showEditView.toggle()
                        }
                        
                    }
            }
            }
            
            CloseSheetButtonView(sheetToggle: $showTransactionDetailView)
            
        }
    }
    
    //MARK: FUNCTIONS
    
    //onDelete Function
    func remove(at offsets: IndexSet) {
        for index in offsets {
            let item = vm.vm.transList[index]
            vm.portfolioDataService.deleteItem(entity: item, coin: vm.coin)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    //Crypto Transaction Detail
    private func tranSegue(tran: TransEntity) {
        selectedTran = tran
        showTransactionDetailView.toggle()
    }
    
}

//MARK: PREVIEW
struct CryptoTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CryptoTransactionView(coin: dev.coin)
        }
    }
}
