//
//  IRTransactionView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 2/1/22.
//

import SwiftUI

struct TomanTransactionView: View {
    
    @ObservedObject var vm = HomeViewModel()
    
    @State private var animationAmount = 0.3
    
    @State private var selectedTran: IREntity? = nil
    
    @State private var showFilteredView: Bool = false
    @State private var showTomanDetailView: Bool = false
    @State private var showEditView: Bool = false
    
    @State private var selectedAccount: String = ""
    
    @State private var amountText: String = ""
    @State private var noteText: String = ""
    
    @State private var showBankDetailView: Bool = false
    
    
    @FocusState private var amountIsFocused: Bool
    @FocusState private var noteIsFocused: Bool
    
    
    @State var selectedAccountID: ObjectIdentifier?
    
    let gradient = LinearGradient(gradient: Gradient(colors: [Color.theme.green, Color.theme.tgBlue]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    
    
    
    var body: some View {
        ZStack {
            List {
                //                MARK: FUTURE
                //                Section {} header: {cardView}
                Section {
                    //Filtered Transactions
                    //                    if showFilteredView {tomanFilteredTransactionView}
                    //All Transactions
                    //                    else {
                    tomanAllTransactionView
                    
                    //                    }
                }
            }
            .environment(\.locale, Locale.init(identifier: vm.translateState ? "en" : "ar"))
            .environment(\.layoutDirection, vm.translateState ? .leftToRight : .rightToLeft)
        }
        .sheet(isPresented: $showTomanDetailView, content: {tomanDetailView})
    }
}

//MARK: EXTENSIONS
extension TomanTransactionView {
    
    
    //MARK: Transacation List
    private var tomanAllTransactionView: some View {
        ForEach(vm.portfolioDataService.irEntities) {item in
            HStack{
                let amountCount = item.amount
                Image(systemName: amountCount > 0 ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                    .foregroundColor(amountCount > 0 ? Color.theme.green : Color.theme.red)
                VStack(alignment: .leading) {
                    HStack(spacing: 5) {
                        Text("toman_sign")
                            .font(Font.custom("BYekan+", size: 14))
                        Text(vm.translateState ? "\(item.amount.asTomanWithTwoDecimalsEng())" : "\(item.amount.asTomanWith2Decimals())")
                            .font(Font.custom("BYekan+", size: 16))
                    }
                    
                    let newTethPrice = ((vm.tethPrice ?? "") as NSString).doubleValue
                    let newPrice = item.amount / newTethPrice * 10
                    
                    if newPrice.isZero || newPrice.isInfinite {
                        Text("$ 10")
                            .redacted(reason: .placeholder)
                            .opacity(animationAmount)
                            .animation(Animation
                                .easeInOut(duration: 1)
                                .repeatForever(autoreverses: true), value: animationAmount)
                            .onAppear { animationAmount = 0.8 }
                    } else {
                        Text(vm.translateState ? "\(newPrice.asDollarWithTwoDecimalsEng())" : "\(newPrice.asCurrencyWith2Decimals())")
                            .font(Font.custom("BYekan+", size: 14))
                            .foregroundColor(Color.theme.SecondaryText)
                    }
                }
                
                Spacer()
                VStack(alignment: .trailing) {
                    
                    Text(vm.translateState ? "\(item.date?.asShortDateStringENG() ?? "")" : "\(item.date?.asShortDateString() ?? "")")
                        .font(Font.custom("BYekan+", size: 14))
                    
                    Text(vm.translateState ? "\(item.date?.asEnglishTimeString() ?? "")" : "\(item.date?.asPersianTimeString() ?? "")")
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
    
    //MARK: Toman Details
    private var tomanDetailView: some View {
        ZStack {
            List {
                Section {
                    //MARK: Amount
                    HStack {
                        HStack(spacing: 5) {
                            Text("amount").font(Font.custom("BYekan+", size: 16))
                            Spacer()
                            if showEditView {
                                HStack {
                                    TextField("", text: $amountText)
                                        .focused($amountIsFocused)
                                        .multilineTextAlignment(.leading)
                                        .font(vm.translateState ? Font.custom("BYekan+", size: 14) : Font.custom("BYekan", size: 14))
                                        .padding(10)
                                        .background(.ultraThinMaterial).cornerRadius(10)
                                        .onTapGesture {
                                            amountIsFocused = true
                                        }
                                        .onAppear { self.amountText = selectedTran?.amount.asCryptoUnlimitedDecimalEng() ?? "" }
                                }
                                
                            } else {
                                Text("toman_sign")
                                    .font(Font.custom("BYekan+", size: 14))
                                Text(vm.translateState ? "\(selectedTran?.amount.asTomanWithTwoDecimalsEng() ?? "-")" : "\(selectedTran?.amount.asTomanWith2Decimals() ?? "-")").font(Font.custom("BYekan+", size: 14))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if showEditView {
                        //MARK: Time and Date
                        HStack {
                            HStack {
                                DatePicker(selection: $vm.dateAdded , label: { Text("time_date")})
                                    .font(Font.custom("BYekan+", size: 16))
                                    .datePickerStyle(.compact)
                                    .environment(\.calendar,Calendar(identifier: vm.translateState ? .gregorian : .persian))
                                    .padding(.horizontal)
                            }
                            .onAppear { self.vm.dateAdded = selectedTran?.date ?? Date.now }
                        }
                    } else {
                        
                        HStack{
                            Text("date").font(Font.custom("BYekan+", size: 16))
                            Spacer()
                            Text(vm.translateState ? "\(selectedTran?.date?.asShortDateStringENG() ?? "")" : "\(selectedTran?.date?.asShortDateString() ?? "")").font(Font.custom("BYekan+", size: 14))
                            
                        }
                        .padding(.horizontal)
                        
                        HStack{
                            
                            Text("time").font(Font.custom("BYekan+", size: 16))
                            Spacer()
                            Text(vm.translateState ? "\(selectedTran?.date?.asEnglishTimeString() ?? "")" : "\(selectedTran?.date?.asPersianTimeString() ?? "")").font(Font.custom("BYekan+", size: 14))
                            
                        }
                        .padding(.horizontal)
                    }
                    
                    //MARK: FUTURE
                    //                    HStack{
                    //                        Text("\(selectedTran?.bank?.name ?? "")").font(Font.custom("BYekan+", size: 14))
                    //                        Spacer()
                    //                        Text("حساب:").font(Font.custom("BYekan+", size: 16))
                    //                    }
                    //                    .padding(.horizontal)
                    //
                    //                    HStack{
                    //                        Text("\(selectedTran?.bank?.code.asCreaditCardString() ?? "")").font(Font.custom("BYekan+", size: 14))
                    //                        Spacer()
                    //                        Text("شماره کارت:").font(Font.custom("BYekan+", size: 16))
                    //                    }
                    //                    .padding(.horizontal)
                    
                    
                    //MARK: NOTE
                    VStack(alignment: .leading) {
                        HStack{
                            
                            Text("note").font(Font.custom("BYekan+", size: 16))
                            Spacer()
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
                    
                    //MARK: Submit Button
                } footer: {
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action:  {if showEditView {
                                vm.portfolioDataService.editToman(amount: Double(amountText) ?? 0, date: vm.dateAdded, note: noteText, entity: selectedTran!)
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
                            .background(Color.theme.background.opacity(0.001)).onTapGesture {
                                if showEditView {
                                    vm.portfolioDataService.editToman(amount: Double(amountText) ?? 0, date: vm.dateAdded, note: noteText, entity: selectedTran!)
                                    showEditView.toggle()
                                } else {
                                    showEditView.toggle()
                                }
                            }
                            Spacer()
                        }.padding()
                        
                    }
                }
            }
            .environment(\.layoutDirection, vm.translateState ? .leftToRight : .rightToLeft)
            CloseSheetButtonView(sheetToggle: $showTomanDetailView)
            
        }
    }
    
    //MARK: FUTURE
    //    private var tomanFilteredTransactionView: some View {
    //        ForEach(vm.portfolioDataService.irEntities.filter({ $0.bank?.name == selectedAccount })) {item in
    //            HStack{
    //                let amountCount = item.amount
    //                Image(systemName: amountCount > 0 ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
    //                    .foregroundColor(amountCount > 0 ? Color.theme.green : Color.theme.red)
    //                VStack(alignment: .leading) {
    //                    HStack(spacing: 5) {
    //                        Text("toman_sign")
    //                            .font(Font.custom("BYekan+", size: 14))
    //                        Text("\(item.amount.asTomanWith2Decimals())")
    //                            .font(Font.custom("BYekan+", size: 16))
    //                    }
    //
    //                    let newTethPrice = ((vm.tethPrice ?? "") as NSString).doubleValue
    //                    let newPrice = item.amount / newTethPrice
    //
    //                    if newPrice.isZero || newPrice.isInfinite {
    //                        Text("$ 10")
    //                            .redacted(reason: .placeholder)
    //                            .opacity(animationAmount)
    //                            .animation(Animation
    //                                        .easeInOut(duration: 1)
    //                                        .repeatForever(autoreverses: true), value: animationAmount)
    //                            .onAppear { animationAmount = 0.8 }
    //                    } else {
    //                        Text("\(newPrice.asCurrencyWith2Decimals())")
    //                            .font(Font.custom("BYekan+", size: 14))
    //                            .foregroundColor(Color.theme.SecondaryText)
    //                    }
    //                }
    //
    //                Spacer()
    //
    //                VStack(alignment: .trailing) {
    //
    //                    Text(vm.translateState ? "\(item.date?.asShortDateStringENG() ?? "")" : "\(item.date?.asShortDateString() ?? "")")
    //                        .font(Font.custom("BYekan+", size: 14))
    //
    //                    Text(vm.translateState ? "\(item.date?.asEnglishTimeString() ?? "")" : "\(item.date?.asPersianTimeString() ?? "")")
    //                        .font(Font.custom("BYekan+", size: 10))
    //
    //                }
    //            }
    //            .background(Color.theme.background.opacity(0.001))
    //            .onTapGesture {
    //                tranSegue(tran: item)
    //            }
    //        }
    //    }
    
    
    
    //    private var cardView: some View {
    //        VStack {
    //            ScrollView(.horizontal, showsIndicators: false){
    //                HStack(spacing: -15) {
    //                    ForEach(vm.portfolioDataService.bankEntities, id: \.self) {item in
    //
    //                        CardView(code: item.code, name: item.name)
    //                            .opacity(item.id == selectedAccountID && showFilteredView ? 1 : 0.7)
    //                            .onTapGesture {
    //
    //                                withAnimation(.easeIn) {
    //                                    if item.id ==  selectedAccountID {
    //                                        showFilteredView.toggle()
    //                                    } else {
    //                                        showFilteredView = true
    //                                    }
    //
    //                                    selectedAccount = item.name ?? ""
    //                                    selectedAccountID = item.id
    //                                }
    //                            }
    //                    }
    //                }.foregroundColor(Color.theme.bwColor)
    //            }
    //        }
    //    }
    
    //MARK: FUNCTIONS
    //onDelete Function
    private func remove(at offsets: IndexSet) {
        for index in offsets {
            let item = vm.portfolioDataService.irEntities[index]
            vm.portfolioDataService.deleteIRItem(entity: item)
        }
    }
    
    //Toman Transaction Detail
    private func tranSegue(tran: IREntity) {
        selectedTran = tran
        showTomanDetailView.toggle()
    }
}



//MARK: PREVIEW
struct TomanTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TomanTransactionView()
    }
}
