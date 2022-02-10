//
//  PortfolioView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/7/22.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var priceText: String = ""
    @State private var noteText: String = ""
    @State private var showCheckmark: Bool = false
    @State private var sold: Bool = false
    @State private var moreOptions: Bool = false
    @State private var tomanSelector: Bool = false
    @State private var cryptoSelector: Bool = false
    @State private var sekkeSelector: Bool = false
    @ObservedObject var monitor = NetworkMonitor()
    
    @FocusState private var amountIsFocused: Bool
    @FocusState private var noteIsFocused: Bool
    @FocusState private var priceIsFocused: Bool
    @FocusState private var searchIsFocused: Bool
    
    private let portfolioDataService = PortfolioDataService()
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        
                        RoundedRectangle(cornerRadius: 15).stroke(cryptoSelector ? Color.theme.green : Color.theme.accent.opacity(0.2), lineWidth: 1).frame(width: 100, height: 100).overlay {
                            VStack {
                                Image(systemName: cryptoSelector ? "bitcoinsign.square.fill" : "bitcoinsign.square").resizable().scaledToFit().foregroundColor(Color.theme.accent).frame(width: 45, height: 45).padding()
                                Text("رمز ارز").padding(.bottom, 15).font(Font.custom("BYekan", size: 20))
                            }
                            
                        }
                        
                        .onTapGesture { withAnimation {
                            cryptoSelector.toggle()
                            tomanSelector = false
                            sekkeSelector = false
                            quantityText = ""
                        }
                            
                        }
                        RoundedRectangle(cornerRadius: 15).stroke(tomanSelector ? Color.theme.green : Color.theme.accent.opacity(0.2), lineWidth: 1).frame(width: 100, height: 100).overlay {
                            
                            VStack {
                                Image(systemName: tomanSelector ? "creditcard.fill" : "creditcard").resizable().scaledToFit().foregroundColor(Color.theme.accent).frame(width: 45, height: 45).padding()
                                Text("تومان").padding(.bottom, 15).font(Font.custom("BYekan", size: 20))
                            }
                            
                        }
                        .onTapGesture { withAnimation {
                            tomanSelector.toggle()
                            cryptoSelector = false
                            sekkeSelector = false
                            quantityText = ""
                        }
                        }
                        
                        RoundedRectangle(cornerRadius: 15).stroke(sekkeSelector ? Color.theme.green : Color.theme.accent.opacity(0.2), lineWidth: 1).frame(width: 100, height: 100).overlay {
                            VStack {
                                Image(systemName: sekkeSelector ? "circlebadge.2.fill" : "circlebadge.2").resizable().scaledToFit().foregroundColor(Color.theme.accent).frame(width: 45, height: 45).padding()
                                Text("طلا و سکه").padding(.bottom, 15).font(Font.custom("BYekan", size: 20))
                            }
                            
                        }
                        
                        .onTapGesture { withAnimation {
                            sekkeSelector.toggle()
                            tomanSelector = false
                            cryptoSelector = false
                            quantityText = ""
                        }
                        }
                    }
                    if cryptoSelector {
                        cryptoSelectorView
                    } else if tomanSelector {
                        tomanSelectorView
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { withAnimation{
                        presentationMode.wrappedValue.dismiss()
                    }
                        HapticManager.impact(style: .soft)
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("بستن") {
                        amountIsFocused = false
                        noteIsFocused = false
                        priceIsFocused = false
                        searchIsFocused = false
                    }
                    .font(Font.custom("BYekan", size: 18))
                }
            })
            //remove new coin input section after search bar get empty
            .onChange(of: vm.searchField) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
            
            //            .navigationBarItems(leading: Button(action: {
            //                presentationMode.wrappedValue.dismiss()
            //            }, label: {
            //                Image(systemName: "xmark.circle.fill")
            //                    .font(.headline)
            //            }) )
        }
    }
}

//MARK: PREVIEW
struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            PortfolioView()
                .environmentObject(dev.homeVM)
    //            .preferredColorScheme(.dark)
        }
        
    }
}

//EXTENSIONS
extension PortfolioView {
    
    private var cryptoSelectorView: some View {
        
        ZStack {

            VStack(alignment: .trailing, spacing: 0) {
                
                HStack {
                    if !monitor.isConnected {
                                Image(systemName: "wifi.slash")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.theme.red)
                                    .frame(width: 35, height: 35)
                        .padding(.horizontal, 5)}
                    
                    SearchBarView(searchField: $vm.searchField)
                        .focused($searchIsFocused)
                        .onTapGesture {
                            searchIsFocused = true
                        }
                    .padding()
                }.padding(.horizontal)
                
                logoList
                
                if selectedCoin != nil {
                    portfolioInputSection
                }
            }
            
        }
    }
    
    //View: Logo List
    private var logoList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 10) {
                
                ForEach(vm.searchField.isEmpty ? vm.portfolioCoins : vm.allCoins) {coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.theme.accent.opacity(0.2), lineWidth: 1)
                        )
                        .padding(5)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                                HapticManager.impact(style: .soft)
                            }
                        }
                }
            }
        })
    }
    
    private var tomanSelectorView: some View {
        tomanInputSection
    }
    
    private var stateSelector: some View {
        HStack{
            
            Text(tomanSelector ? "واریز" : "خرید")
                .onTapGesture {
                    sold = false
                }
                .foregroundColor(sold ? Color.theme.SecondaryText : Color.theme.green).padding(.horizontal)
            
            Text(tomanSelector ? "برداشت" : "فروش").onTapGesture {
                sold = true
            }
            .foregroundColor(sold ? Color.theme.red : Color.theme.SecondaryText).padding(.horizontal)
        }
        .padding()
        .background(.ultraThinMaterial).cornerRadius(15)
        .foregroundColor(Color.theme.SecondaryText)
        .font(Font.custom("BYekan", size: 18))
        
    }
    
    private var baseInputDetails: some View {
        HStack {
            TextField("", text: $quantityText)
                .focused($amountIsFocused)
                .multilineTextAlignment(.leading)
                .font(Font.custom("BYekan", size: 18))
                .keyboardType(tomanSelector ? .asciiCapableNumberPad : .decimalPad)
                .padding()
                .background(.ultraThinMaterial).cornerRadius(10)
                .onTapGesture {
                    amountIsFocused = true
                            }
//                .shadow(color: Color.theme.shadowColor.opacity(0.6), radius: 5, x: 0, y: 0)
                .padding()
            
            Spacer()
            Text("مقدار:")
                .font(Font.custom("BYekan+", size: 16))
            Spacer()
        }
    }
    
    private var tomanInputSection: some View {
        VStack(spacing: 20) {
            stateSelector
            baseInputDetails
            
            VStack(alignment: .trailing) {
                HStack {
                    TextField("", text: $noteText)
                        .focused($noteIsFocused)
                        .font(Font.custom("BYekan", size: 16))
                        .multilineTextAlignment(.trailing)
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .onTapGesture {
                                        noteIsFocused = true
                                    }
//                        .shadow(color: Color.theme.shadowColor.opacity(0.6), radius: 5, x: 0, y: 0)
                        .padding()

                        
                    
                    Spacer()
                    Text("یادداشت:")
                        .font(Font.custom("BYekan+", size: 16))
                    //                            .frame(height: 150)
                    
                }
                
                HStack {
                    DatePicker(selection: $vm.dateAdded , label: { Text("تاریخ:")})
                        .font(Font.custom("BYekan+", size: 16))
                        .datePickerStyle(.compact)
                        .environment(\.locale, Locale.init(identifier: "fa_IR"))
                        .environment(\.calendar,Calendar(identifier: .persian))
                        .environment(\.layoutDirection, .rightToLeft)
                        .padding(.leading)
                }
            }
        }
        .padding()
        //        .font(.headline)
    }
    
    //View: Portfolio Input Sections
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            if moreOptions {
                stateSelector
                baseInputDetails
                
                Divider()
                
                VStack(alignment: .trailing) {
                    HStack {
                        Text("\(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")")
                            .font(Font.custom("BYekan+", size: 14))
                            .foregroundColor(Color.theme.accent)
                            .padding(6)
                            .background(.ultraThinMaterial).cornerRadius(10)
                            .onTapGesture {
                                priceText = selectedCoin?.currentPrice.asCurrencyWith6DecimalsENG() ?? ""
                                HapticManager.impact(style: .soft)
                                
                            }
                        
                        Text("قیمت کنونی: ")
                            .font(Font.custom("BYekan+", size: 14))
                    }
                    
                    HStack {
                        TextField("", text: $priceText)
                            .focused($priceIsFocused)
                            .font(Font.custom("BYekan", size: 16))
                            .multilineTextAlignment(.leading)
                            .keyboardType(.decimalPad)
                        
                            .padding()
                            .background(.ultraThinMaterial).cornerRadius(10)
                            .onTapGesture {
                                            priceIsFocused = true
                                        }
                            .padding()
                            .onAppear {
                                self.priceText = selectedCoin?.currentPrice.asCurrencyWith6DecimalsENG() ?? ""
                            }
                        
                        Spacer()
                        Text("قیمت خرید:")
                            .font(Font.custom("BYekan+", size: 16))
                            .frame(height: 50)
                        
                        //                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                        //                Spacer()
                        //                Text("قیمت کنونی \(selectedCoin?.symbol.uppercased() ?? "")")
                    }
                    
                    
                    HStack {
                        TextField("", text: $noteText)
                            .focused($noteIsFocused)
                            .font(Font.custom("BYekan", size: 16))
                            .multilineTextAlignment(.trailing)
                            .padding()
                            .background(.ultraThinMaterial).cornerRadius(10)
                            .onTapGesture {
                                            noteIsFocused = true
                                        }
    //                        .shadow(color: Color.theme.shadowColor.opacity(0.6), radius: 5, x: 0, y: 0)
                            .padding()

                            
                        
                        Spacer()
                        Text("یادداشت:")
                            .font(Font.custom("BYekan+", size: 16))
                        //                            .frame(height: 150)
                        
                    }
                    
                    
                    HStack {
                        DatePicker(selection: $vm.dateAdded , label: { Text("تاریخ:")})
                            .font(Font.custom("BYekan+", size: 16))
                            .datePickerStyle(.compact)
                            .environment(\.locale, Locale.init(identifier: "fa_IR"))
                            .environment(\.calendar,Calendar(identifier: .persian))
                            .environment(\.layoutDirection, .rightToLeft)
                            .padding(.leading)
                    }
                    
                    HStack {
                        Text("بستن")
                            .font(Font.custom("BYekan", size: 16))
                        Image(systemName: "arrow.up.square.fill")
                    }.onTapGesture {
                        withAnimation {
                            moreOptions.toggle()
                        }
                        
                    }

                }
                
                Divider()
                HStack {
                    Text(getCurentValue().asCurrencyWith2Decimals())
                        .font(Font.custom("BYekan+", size: 16))
                    Spacer()
                    Text("ارزش فعلی:")
                        .font(Font.custom("BYekan+", size: 16))
                }
                HStack {
                    Text(getBuyValue().asCurrencyWith2Decimals())
                        .font(Font.custom("BYekan+", size: 16))
                    Spacer()
                    Text("ارزش زمان خرید:")
                        .font(Font.custom("BYekan+", size: 16))
                }
                
                
            } else {
                stateSelector
                baseInputDetails
                
                VStack(alignment: .trailing) {
                    HStack {
                        Text("\(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")")
                            .font(Font.custom("BYekan+", size: 14))
                            .foregroundColor(Color.theme.accent)
                            .padding(6)
                            .background(.ultraThinMaterial).cornerRadius(10)
                            .onTapGesture {
                                priceText = selectedCoin?.currentPrice.asCurrencyWith6DecimalsENG() ?? ""
                                HapticManager.impact(style: .soft)
                                
                            }
                        
                        Text("قیمت کنونی: ")
                            .font(Font.custom("BYekan+", size: 14))
                    }
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            Text("بیشتر")
                                .font(Font.custom("BYekan", size: 16))
                            Image(systemName: "arrow.down.square.fill")
                        }.onTapGesture {
                            withAnimation {
                                moreOptions.toggle()
                            }
                        }
                    }
                    
                    Divider()
                    HStack {
                        Text(getCurentValue().asCurrencyWith2Decimals())
                            .font(Font.custom("BYekan+", size: 16))
                        Spacer()
                        Text("ارزش فعلی:")
                            .font(Font.custom("BYekan+", size: 16))
                    }
                }
            }
        }
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButton: some View {
        HStack(spacing: 10) {
            //            Image(systemName: ).foregroundColor(Color.theme.green)
            //                .font(.title)
            //                .opacity( 1.0 : 0.0)
            
            //                Image(systemName: showCheckmark ? "checkmark.circle.fill" : "plus.circle.fill")
            //                    .disabled((!showCheckmark && selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? false : true )
            //                    .foregroundColor(showCheckmark ? Color.theme.green : Color.theme.accent)
            //                    .font(.title)
            
            Button {
                saveButtonPressed()
                HapticManager.notification(type: showCheckmark ? .success : .error)
            } label: {
                
                if showCheckmark {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.theme.green)
                        .font(.title)
                } else if (Double(quantityText) != nil && Double(quantityText) != 0) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color.theme.accent)
                        .font(.title)
                } else {
                    Image(systemName: "plus.circle.fill")
                        .disabled(true)
                        .font(.title)
                }
            }
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let _ = portfolioCoin.currentHoldings {
            quantityText = ""
        } else {
            quantityText = ""
        }
    }
    
    private func getCurentValue() -> Double {
        
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
            
        }
        return 0
    }
    
    private func getBuyValue() -> Double {
        
        guard let quantityNum = Double(quantityText), let buyPrice = Double(priceText) else {return 0}
        return (quantityNum * buyPrice)
    }
    
    
    private func saveButtonPressed() {
        if tomanSelector {
            
            guard let amount = Double(quantityText), amount != 0
                    
            else { return }
            
            //save to portfolio
            if sold {
                portfolioDataService.addCustom(amount: (amount * -1), date: vm.dateAdded, note: noteText )
            } else {
                portfolioDataService.addCustom(amount: amount, date: vm.dateAdded, note: noteText)
            }
            
            //show checkmark
            withAnimation(.easeIn) {
                showCheckmark = true
                removeSelectedCoin()
            }
            
            //hide keyboard
            UIApplication.shared.endEditing()
            
            //hide checkmark
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut) {
                    showCheckmark = false
                }
                vm.irAmountCalc()
                vm.dateAdded = Date.now
            }
            
        } else {
            guard let coin = selectedCoin,
                  let amount = Double(quantityText), amount != 0
                    
            else { return }
            
            //save to portfolio
            if sold {
                vm.updatePortfolio(coin: coin, amount: (amount * -1), date: vm.dateAdded)
            } else {
                vm.updatePortfolio(coin: coin, amount: amount, date: vm.dateAdded)
            }
            
            
            
            
            //show checkmark
            withAnimation(.easeIn) {
                showCheckmark = true
                removeSelectedCoin()
            }
            
            //hide keyboard
            UIApplication.shared.endEditing()
            
            //hide checkmark
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut) {
                    showCheckmark = false
                }
            }
        }
        
    }
    
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchField = ""
    }
    
    
}
