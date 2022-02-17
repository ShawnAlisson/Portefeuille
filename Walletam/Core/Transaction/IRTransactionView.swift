//
//  IRTransactionView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 2/1/22.
//

import SwiftUI

struct IRTransactionView: View {
    
    @ObservedObject var vm = HomeViewModel()
    @State private var animationAmount = 0.3
    @State private var irDetailView: Bool = false
    @State private var selectedTran: IREntity? = nil
    @State private var showFilteredView: Bool = false
    @State private var selectedAccount: String = ""
    @State var selectedAccountID: ObjectIdentifier?

    var body: some View {
        ZStack {
            List {
                Section {
                    
                } header: {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: -15) {
                            ForEach(vm.portfolioDataService.bankEntities, id: \.self) {item in
                                
                                CardView(code: item.code, name: item.name)
                                    .opacity(item.id == selectedAccountID && showFilteredView ? 1 : 0.7)
                                    .onTapGesture {
                                        
                                        withAnimation(.easeIn) {
                                            if item.id ==  selectedAccountID {
                                                showFilteredView.toggle()
                                            } else {
                                                showFilteredView = true
                                            }
                                            
                                            selectedAccount = item.name ?? ""
                                            selectedAccountID = item.id
                                        }
                                    }
                            }
                        }.foregroundColor(Color.theme.bwColor)
                    }
                }.frame(width:UIScreen.main.bounds.width)
                    
            }
                Section {
                    //Filtered Transactions
                    if showFilteredView {
                        ForEach(vm.portfolioDataService.irEntities.filter({ $0.bank?.name == selectedAccount })) {item in
                            HStack{
                                let amountCount = item.amount
                                Image(systemName: amountCount > 0 ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                                    .foregroundColor(amountCount > 0 ? Color.theme.green : Color.theme.red)
                                VStack(alignment: .leading) {
                                    HStack(spacing: 5) {
                                        Text("تومان")
                                            .font(Font.custom("BYekan+", size: 14))
                                        Text("\(item.amount.asCryptoUnlimitedDecimal())")
                                            .font(Font.custom("BYekan+", size: 16))
                                    }
                                    
                                    let newTethPrice = ((vm.tethPrice ?? "") as NSString).doubleValue
                                    let newPrice = item.amount / newTethPrice
                                    
                                    if newPrice.isZero || newPrice.isInfinite {
                                        Text("$ 10")
                                            .redacted(reason: .placeholder)
                                            .opacity(animationAmount)
                                            .animation(Animation
                                                        .easeInOut(duration: 1)
                                                        .repeatForever(autoreverses: true), value: animationAmount)
                                            .onAppear { animationAmount = 0.8 }
                                    } else {
                                        Text("\(newPrice.asCurrencyWith2Decimals())")
                                            .font(Font.custom("BYekan+", size: 14))
                                            .foregroundColor(Color.theme.SecondaryText)
                                    }
                                }
                            
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    
                                    Text("\(item.date?.asShortDateString() ?? "")")
                                        .font(Font.custom("BYekan+", size: 14))
                                    
                                    Text("\(item.date?.asPersianTimeString() ?? "")")
                                        .font(Font.custom("BYekan+", size: 10))
                                    
                                }
                            }
                            .background(Color.theme.background.opacity(0.001))
                            .onTapGesture {
                                tranSegue(tran: item)
                            }
                        }
                    }
                    //All Transactions
                    else {
                        ForEach(vm.portfolioDataService.irEntities) {item in
                            HStack{
                                let amountCount = item.amount
                                Image(systemName: amountCount > 0 ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                                    .foregroundColor(amountCount > 0 ? Color.theme.green : Color.theme.red)
                                VStack(alignment: .leading) {
                                    HStack(spacing: 5) {
                                        Text("تومان")
                                            .font(Font.custom("BYekan+", size: 14))
                                        Text("\(item.amount.asCryptoUnlimitedDecimal())")
                                            .font(Font.custom("BYekan+", size: 16))
                                    }
                                    
                                    let newTethPrice = ((vm.tethPrice ?? "") as NSString).doubleValue
                                    let newPrice = item.amount / newTethPrice
                                    
                                    if newPrice.isZero || newPrice.isInfinite {
                                        Text("$ 10")
                                            .redacted(reason: .placeholder)
                                            .opacity(animationAmount)
                                            .animation(Animation
                                                        .easeInOut(duration: 1)
                                                        .repeatForever(autoreverses: true), value: animationAmount)
                                            .onAppear { animationAmount = 0.8 }
                                    } else {
                                        Text("\(newPrice.asCurrencyWith2Decimals())")
                                            .font(Font.custom("BYekan+", size: 14))
                                            .foregroundColor(Color.theme.SecondaryText)
                                    }
                                }
                                
                                Spacer()
                                VStack(alignment: .trailing) {
                                    
                                    Text("\(item.date?.asShortDateString() ?? "")")
                                        .font(Font.custom("BYekan+", size: 14))
                                    
                                    Text("\(item.date?.asPersianTimeString() ?? "")")
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
            .environment(\.locale, Locale.init(identifier: "de"))
        }
        .sheet(isPresented: $irDetailView, content: {
            ZStack {
                List {
                    Section {
                        HStack {
                            HStack(spacing: 5) {
                                Text("تومان")
                                    .font(Font.custom("BYekan+", size: 14))
                                Text("\(selectedTran?.amount.asTomanWith2Decimals() ?? "-")").font(Font.custom("BYekan+", size: 14))
                            }
                            Spacer()
                            Text("مقدار:").font(Font.custom("BYekan+", size: 16))
                        }
                        .padding(.horizontal)
                        
                        HStack{
                            Text("\(selectedTran?.date?.asShortDateString() ?? "")").font(Font.custom("BYekan+", size: 14))
                            Spacer()
                            Text("تاریخ:").font(Font.custom("BYekan+", size: 16))
                        }.padding(.horizontal)
                        
                        HStack{
                            Text("\(selectedTran?.bank?.name ?? "")").font(Font.custom("BYekan+", size: 14))
                            Spacer()
                            Text("حساب:").font(Font.custom("BYekan+", size: 16))
                        }.padding(.horizontal)
                        
                        HStack{
                            Text("\(selectedTran?.bank?.code.asCreaditCardString() ?? "")").font(Font.custom("BYekan+", size: 14))
                            Spacer()
                            Text("شماره کارت:").font(Font.custom("BYekan+", size: 16))
                        }.padding(.horizontal)
                        
                        HStack{
                            Text("\(selectedTran?.date?.asPersianTimeString() ?? "")").font(Font.custom("BYekan+", size: 14))
                            Spacer()
                            Text("ساعت:").font(Font.custom("BYekan+", size: 16))
                        }.padding(.horizontal)
                        
                        VStack(alignment: .trailing) {
                            HStack{
                                Spacer()
                                Text("یادداشت:").font(Font.custom("BYekan+", size: 16))
                            }
                            
                            Text("\(selectedTran?.note ?? "")").font(Font.custom("BYekan+", size: 16))
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.horizontal)
                    }
                header: {
                    
                }
                }
                
                VStack{
                    HStack{
                        Spacer()
                        RoundedRectangle(cornerRadius: 15).frame(width: 60, height: 4).foregroundColor(Color.theme.SecondaryText.opacity(0.5))
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 10)
            }
        })
    }
    
    private func remove(at offsets: IndexSet) {
        for index in offsets {
            let item = vm.portfolioDataService.irEntities[index]
            vm.portfolioDataService.deleteIRItem(entity: item)
            
        }
    }
    
    private func tranSegue(tran: IREntity) {
        selectedTran = tran
        irDetailView.toggle()
    }
}

struct IRTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        
            IRTransactionView()
        
            
    }
}
