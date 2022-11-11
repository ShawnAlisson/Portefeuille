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
    
    //Gradient for Submit Button
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.theme.green, Color.theme.tgBlue]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CryptoTransactionViewModel(coin: coin))
    }
    
    var body: some View {
        VStack {
            ChartView(coin: vm.coin)
            
            //MARK: Transaction List
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
                                            Text(vmm.translateState ? "\(item.amount.asCryptoUnlimitedDecimalEng())" : "\(item.amount.asCryptoUnlimitedDecimal())")
                                                .font(Font.custom("BYekan+", size: 16))
                                            Text("\(vm.coin.symbol.uppercased())")
                                                .font(.caption).foregroundColor(Color.theme.SecondaryText)
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text(vmm.translateState ? "\(item.date?.asShortDateStringENG() ?? "")" : "\(item.date?.asShortDateString() ?? "")")
                                    .font(Font.custom("BYekan+", size: 14))
                                Text(vmm.translateState ? "\(item.date?.asEnglishTimeString() ?? "")" : "\(item.date?.asPersianTimeString() ?? "")")
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
    
    //MARK: Detail View
    private var transactionDetailView: some View {
        ZStack {
            List {
                Section {
                    //MARK: Amount
                    HStack {
                        Text("amount").font(Font.custom("BYekan+", size: 16))
                        Spacer()
                        if showEditView {
                            HStack {
                                TextField("", text: $amountText)
                                    .focused($amountIsFocused)
                                    .multilineTextAlignment(.leading)
                                    .font(vmm.translateState ? Font.custom("BYekan+", size: 14) : Font.custom("BYekan", size: 14))
                                    .padding(10)
                                    .background(.ultraThinMaterial).cornerRadius(10)
                                    .onTapGesture {
                                        amountIsFocused = true
                                    }
                                    .onAppear { self.amountText = selectedTran?.amount.asCryptoUnlimitedDecimalEng() ?? "" }
                            }
                        } else {
                            HStack(spacing: 5) {
                                Text(vmm.translateState ? "\(selectedTran?.amount.asCryptoUnlimitedDecimalEng() ?? "-")" : "\(selectedTran?.amount.asCryptoUnlimitedDecimal() ?? "-")").font(Font.custom("BYekan+", size: 14))
                            }
                        }
                        
                        
                        
                    }
                    .padding(.horizontal)
                    
                    //MARK: BUY/SELL Price/Value
                    HStack{
                        Text(((selectedTran?.amount ?? 0) > 0) ? "buy_price" : "sell_price").font(Font.custom("BYekan+", size: 16))
                        Spacer()
                        if showEditView {
                            HStack {
                                TextField("", text: $buyPriceText)
                                    .focused($buyPriceIsFocused)
                                    .multilineTextAlignment(.leading)
                                    .font(vmm.translateState ? Font.custom("BYekan+", size: 14) : Font.custom("BYekan", size: 14))
                                    .padding(10)
                                    .background(.ultraThinMaterial).cornerRadius(10)
                                    .onTapGesture {
                                        buyPriceIsFocused = true
                                    }
                                    .onAppear { self.buyPriceText = selectedTran?.buyPrice.asCryptoUnlimitedDecimalEng() ?? "" }
                            }
                        } else {
                            Text(vmm.translateState ? "\(selectedTran?.buyPrice.asDollarWithTwoDecimalsEng() ?? "-" )" : "\(selectedTran?.buyPrice.asCurrencyWith2Decimals() ?? "-" )").font(Font.custom("BYekan+", size: 14))
                        }
                        
                    }.padding(.horizontal)
                    
                    if !showEditView {
                        HStack{
                            Text(((selectedTran?.amount ?? 0) > 0) ? "buy_value" : "sell_value").font(Font.custom("BYekan+", size: 16))
                            Spacer()
                            Text(vmm.translateState ? ((selectedTran?.buyPrice ?? 0) * (selectedTran?.amount ?? 0)).asDollarWithTwoDecimalsEng() : ((selectedTran?.buyPrice ?? 0) * (selectedTran?.amount ?? 0)).asCurrencyWith2Decimals()).font(Font.custom("BYekan+", size: 14))
                            
                        }.padding(.horizontal)
                    }
                    
                    
                    
                    if showEditView {
                        //MARK: Date and Time
                        HStack {
                            HStack {
                                DatePicker(selection: $vmm.dateAdded , label: { Text("time_date")})
                                    .font(Font.custom("BYekan+", size: 16))
                                    .datePickerStyle(.compact)
                                    .environment(\.calendar,Calendar(identifier: vmm.translateState ? .gregorian : .persian))
                                
                                    .padding(.horizontal)
                            }
                            .onAppear { self.vmm.dateAdded = selectedTran?.date ?? Date.now }
                        }
                    } else {
                        HStack{
                            
                            Text("date").font(Font.custom("BYekan+", size: 16))
                            Spacer()
                            Text(vmm.translateState ? "\(selectedTran?.date?.asShortDateStringENG() ?? "")" : "\(selectedTran?.date?.asShortDateString() ?? "")").font(Font.custom("BYekan+", size: 14))
                            
                        }.padding(.horizontal)
                        
                        HStack{
                            
                            Text("time").font(Font.custom("BYekan+", size: 16))
                            Spacer()
                            Text(vmm.translateState ? "\(selectedTran?.date?.asEnglishTimeString() ?? "")" : "\(selectedTran?.date?.asPersianTimeString() ?? "")").font(Font.custom("BYekan+", size: 14))
                            
                        }.padding(.horizontal)
                    }
                    
                    
                    VStack(alignment: .leading) {
                        
                        //MARK: Note
                        HStack{
                            Text("note").font(Font.custom("BYekan+", size: 16))
                            Spacer()
                        }
                        if showEditView {
                            HStack {
                                TextField("", text: $noteText)
                                    .focused($noteIsFocused)
                                    .multilineTextAlignment(.leading)
                                    .font(Font.custom("BYekan+", size: 14))
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
                
                //MARK: Submit Button
            footer: {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action:  {if showEditView {
                            vm.portfolioDataService.editCrypto(amount: Double(amountText) ?? 0, note: noteText, buyPrice: Double(buyPriceText) ?? 0, date: vmm.dateAdded, entity: selectedTran!)
                            showEditView.toggle()
                        } else {
                            showEditView.toggle()
                        }}) {
                            Text(showEditView ? "submit" : "edit")
                                .padding()
                        }
                        .font(Font.custom("BYekan+", size: 16))
                        .frame(width: 200, height: 50)
                        
                        .background(Capsule().stroke(gradient, lineWidth: 2))
                        .background(Color.theme.background.opacity(0.001)).onTapGesture {if showEditView {
                            vm.portfolioDataService.editCrypto(amount: Double(amountText) ?? 0, note: noteText, buyPrice: Double(buyPriceText) ?? 0, date: vmm.dateAdded, entity: selectedTran!)
                            showEditView.toggle()
                        } else {
                            showEditView.toggle()
                        }}
                        Spacer()
                    }.padding()
                    
                }
                
                
            }
                
            }
            .environment(\.layoutDirection, vmm.translateState ? .leftToRight : .rightToLeft)
            
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
