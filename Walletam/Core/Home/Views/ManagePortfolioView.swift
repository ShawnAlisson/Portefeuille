//
//  ManagePortfolioView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/7/22.
//

import SwiftUI

struct ManagePortfolioView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm: HomeViewModel
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showCheckmark: Bool = false
    @State private var sold: Bool = false
    @State private var selectedAccount: String = "بدون دسته‌بندی"
    @State private var selectedGoldType: String = "انتخاب کنید"
    
    //Show Views and Sheets
    @State private var showBankView: Bool = false
    @State private var showAddBankView: Bool = false
    @State private var showBankSelectionView: Bool = false
    @State private var showGoldTypeSelectionView: Bool = false
    @State private var moreOptions: Bool = false
    @State private var tomanSelector: Bool = false
    @State private var cryptoSelector: Bool = false
    @State private var goldSelector: Bool = false
    
    //TextFields and Focuses
    @FocusState private var amountIsFocused: Bool
    @FocusState private var noteIsFocused: Bool
    @FocusState private var priceIsFocused: Bool
    @FocusState private var searchIsFocused: Bool
    @FocusState private var nameIsFocused: Bool
    @FocusState private var codeIsFocused: Bool
    @FocusState private var noteIsFocusedForBank: Bool
    @State private var quantityText: String = ""
    @State private var priceText: String = ""
    @State private var noteText: String = ""
    @State private var nameText: String = ""
    @State private var codeText: String = ""
    @State private var noteTextForBank: String = ""
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack {
                        portfolioTypeSelector
                        
                        if cryptoSelector {cryptoSelectorView} else if
                            tomanSelector {tomanSelectorView} else if
                                goldSelector {goldSelectorView}
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
                            nameIsFocused = false
                            codeIsFocused = false
                            noteIsFocusedForBank = false
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
            }
        }
        .sheet(isPresented: $showBankSelectionView, content: {
            bankSelectionView
        })
    }
}

//MARK: EXTENSIONS
extension ManagePortfolioView {
    
    //MARK: VIEWS
    //MARK: GENERAL
    private var portfolioTypeSelector: some View {
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
                goldSelector = false
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
                goldSelector = false
                quantityText = ""
            }
            }
            
            //Future UPDATE
            //            RoundedRectangle(cornerRadius: 15).stroke(goldSelector ? Color.theme.green : Color.theme.accent.opacity(0.2), lineWidth: 1).frame(width: 100, height: 100).overlay {
            //                VStack {
            //                    Image(systemName: goldSelector ? "circlebadge.2.fill" : "circlebadge.2").resizable().scaledToFit().foregroundColor(Color.theme.accent).frame(width: 45, height: 45).padding()
            //                    Text("طلا و سکه").padding(.bottom, 15).font(Font.custom("BYekan", size: 20))
            //                }
            //            }
            //            .onTapGesture { withAnimation {
            //                goldSelector.toggle()
            //                tomanSelector = false
            //                cryptoSelector = false
            //                quantityText = ""
            //            }
            //            }
        }
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
    
    private var trailingNavBarButton: some View {
        HStack(spacing: 10) {
            Button {
                saveButtonPressed()
                HapticManager.notification(type: showCheckmark ? .success : .error)
            } label: {
                
                if showCheckmark {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.theme.green)
                        .font(.title)
                } else if goldSelector && selectedGoldType == "انتخاب کنید" {
                    Image(systemName: "plus.circle.fill")
                        .disabled(true)
                        .font(.title)
                }
                else if (Double(quantityText) != nil && Double(quantityText) != 0) {
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
    
    private var dateSeclectorView: some View {
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
    
    //MARK: CRYPTO
    private var cryptoSelectorView: some View {
        ZStack {
            VStack(alignment: .trailing, spacing: 0) {
                
                HStack {
                    if !vm.monitor.isConnected {
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
                    Spacer()
                    cryptoInputSection
                }
            }
        }
    }
    
    private var cryptoInputSection: some View {
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
                    
                    dateSeclectorView
                    
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
    
    //MARK: TOMAN
    private var tomanSelectorView: some View {
        tomanInputSection
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
                        .padding()
                    
                    Spacer()
                    
                    Text("یادداشت:")
                        .font(Font.custom("BYekan+", size: 16))
                        
                }
                
                HStack {
                    Text(selectedAccount).font(Font.custom("BYekan+", size: 16)).lineLimit(1).minimumScaleFactor(0.1).frame(height: 20).frame(maxWidth: .infinity).padding().background(.ultraThinMaterial).cornerRadius(10).padding()
                        .onTapGesture {
                            showBankSelectionView.toggle()
                        }
                    
                    Spacer()
                    
                    Text("حساب:")
                        .font(Font.custom("BYekan+", size: 16))
                    
                }
                
                dateSeclectorView
            }
        }
        .padding()
    }
    
    private var addBankView: some View {
        VStack{
            HStack {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(Color.theme.accent)
                    .onTapGesture {
                        showAddBankView.toggle()
                        nameText = ""
                        codeText = ""
                        noteTextForBank = ""
                    }.padding().padding(.top, 20)
                Spacer()
            }
            Spacer()
            VStack{
                HStack {
                    TextField("", text: $nameText)
                        .focused($nameIsFocused)
                        .multilineTextAlignment(.leading)
                        .font(Font.custom("BYekan", size: 18))
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .onTapGesture {
                            nameIsFocused = true
                        }
                        .padding()
                    
                    Spacer()
                    Text("نام حساب:")
                        .font(Font.custom("BYekan+", size: 16))
                    Spacer()
                }
                HStack {
                    TextField("", text: $codeText)
                        .limitInputLength(value: $codeText, length: 16)
                        .focused($codeIsFocused)
                        .keyboardType(.asciiCapableNumberPad)
                        .multilineTextAlignment(.leading)
                        .font(Font.custom("BYekan", size: 18))
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .onTapGesture {
                            codeIsFocused = true
                        }
                        .padding()
                    
                    Spacer()
                    Text("شماره کارت:")
                        .font(Font.custom("BYekan+", size: 16))
                    Spacer()
                }
                HStack {
                    TextField("", text: $noteTextForBank)
                        .focused($noteIsFocused)
                        .font(Font.custom("BYekan", size: 16))
                        .multilineTextAlignment(.trailing)
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .onTapGesture {
                            noteIsFocusedForBank = true
                        }
                        .padding()
                    Spacer()
                    Text("یادداشت:")
                        .font(Font.custom("BYekan+", size: 16))
                    Spacer()
                }
            }
            Spacer()
            
            PrimaryButton(image: "plus", showImage: true, text: "افزودن", disabled: (nameText.count > 0) ? false : true)
                .padding()
                .onTapGesture {
                    if (nameText.count > 0) {
                        saveBankInfo(name: nameText, code: codeText, note: noteText)
                        nameText = ""
                        codeText = ""
                        noteTextForBank = ""
                        showAddBankView.toggle()
                        
                    }
                }
        }
    }
    
    private var cardSelectionView: some View {
        VStack {
            HStack{
                Spacer()
                HStack(spacing: 3){
                    
                    Text("حساب جدید")
                        .font(Font.custom("BYekan+", size: 20))
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .frame(width: 30, height: 30)
                }
                .opacity(showAddBankView ? 0 : 1)
                .onTapGesture {
                    showAddBankView.toggle()
                }
            }.padding().padding(.top, 20)
            
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(vm.portfolioDataService.bankEntities) { item in
                        CardVerticalView(code: item.code, name: item.name)
                            .onTapGesture {
                                selectedAccount = item.name ?? ""
                                withAnimation{
                                    showBankSelectionView.toggle()
                                }
                            }
                    }
                }
            }
            .padding()
            
            Spacer()
            
        }
        .onAppear(perform: vm.portfolioDataService.applyChanges)
    }
    
    private var bankSelectionView: some View {
        ZStack {
            if vm.portfolioDataService.bankEntities.isEmpty && !showAddBankView {
                VStack{
                    
                    Spacer()
                    
                    Image(systemName: "creditcard.and.123").resizable().scaledToFit().frame(width: 180, height: 180)
                    Text("هنوز حسابی ساخته نشده!")
                        .font(Font.custom("BYekan+", size: 30))
                    
                    Spacer()
                    
                    PrimaryButton(image: "plus", showImage: true, text: "ساخت حساب جدید")
                        .padding()
                        .onTapGesture {
                            showAddBankView.toggle()
                        }
                }
                
                
            } else if showAddBankView {
                addBankView
                
            } else {
                cardSelectionView
            }
            CloseSheetButtonView(sheetToggle: $showBankSelectionView, disabled: showAddBankView)
        }
    }
    
    //MARK: FUTURE UPDATE
    private var goldSelectorView: some View {
        VStack(spacing: 20){
            stateSelector
            goldTypeSelectionView
            baseInputDetails
            
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
                    .padding()
                
                Spacer()
                
                Text("یادداشت:")
                    .font(Font.custom("BYekan+", size: 16))
            }
            dateSeclectorView
        }.padding()
    }
    
    private var goldTypeSelectionView: some View {
        VStack{
            HStack {
                Text(selectedGoldType).font(Font.custom("BYekan+", size: 16)).lineLimit(1).minimumScaleFactor(0.1).frame(height: 30).frame(maxWidth: .infinity).padding().background(.ultraThinMaterial).cornerRadius(15).padding()
                    .onTapGesture {
                        showGoldTypeSelectionView.toggle()
                    }
                
                Spacer()
                
                Text("نوع سکه یا طلا:")
                    .font(Font.custom("BYekan+", size: 16))
                
            }
            
        }.sheet(isPresented: $showGoldTypeSelectionView, content: {
            ZStack {
                
                VStack {
                    HStack {
                        Text("۸.۱۳ گرم")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        Spacer()
                        Text("تمام سکه")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        
                        
                    }.padding().frame(width: UIScreen.main.bounds.width * 0.9 , height: 100 ).background(.ultraThinMaterial).cornerRadius(15).onTapGesture {
                        selectedGoldType = "تمام سکه"
                    }
                    
                    HStack {
                        Text("۴.۰۷ گرم")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        Spacer()
                        Text("نیم سکه")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        
                        
                    }.padding().frame(width: UIScreen.main.bounds.width * 0.9 , height: 100 ).background(.ultraThinMaterial).cornerRadius(15).onTapGesture {
                        selectedGoldType = "نیم سکه"
                    }
                    
                    HStack {
                        Text("۲.۰۳ گرم")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        Spacer()
                        Text("ربع سکه")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        
                        
                    }.padding().frame(width: UIScreen.main.bounds.width * 0.9 , height: 100 ).background(.ultraThinMaterial).cornerRadius(15).onTapGesture {
                        selectedGoldType = "ربع سکه"
                    }
                    
                    HStack {
                        Text("۱.۰۱ گرم")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        Spacer()
                        Text("سکه یک گرمی")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        
                        
                    }.padding().frame(width: UIScreen.main.bounds.width * 0.9 , height: 100 ).background(.ultraThinMaterial).cornerRadius(15).onTapGesture {
                        selectedGoldType = "سکه یک گرمی"
                    }
                    
                    HStack {
                        Text("۱ گرم")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        Spacer()
                        Text("طلای ۱۸ عیار")
                            .font(Font.custom("BYekan+", size: 24)).lineLimit(1).minimumScaleFactor(0.1)
                        
                        
                    }.padding().frame(width: UIScreen.main.bounds.width * 0.9 , height: 100 ).background(.ultraThinMaterial).cornerRadius(15).padding(30).onTapGesture {
                        selectedGoldType = "طلای ۱۸ عیار"
                    }
                }
                .padding()
                
                
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
    
    //MARK: FUNCTIONS
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
                vm.portfolioDataService.addCustom(amount: (amount * -1), date: vm.dateAdded, note: noteText, bank: selectedAccount )
            } else {
                vm.portfolioDataService.addCustom(amount: amount, date: vm.dateAdded, note: noteText, bank: selectedAccount)
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
            
        } else if cryptoSelector {
            guard let coin = selectedCoin,
                  let amount = Double(quantityText), amount != 0
                    
            else { return }
            
            //save to portfolio
            if sold {
                vm.updatePortfolio(coin: coin, amount: (amount * -1), buyPrice: Double(priceText) ?? (selectedCoin?.currentPrice ?? 0) , date: vm.dateAdded, note: noteText)
            } else {
                vm.updatePortfolio(coin: coin, amount: amount, buyPrice: Double(priceText) ?? (selectedCoin?.currentPrice ?? 0), date: vm.dateAdded, note: noteText)
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
        } else if goldSelector {
            
            guard let amount = Double(quantityText), amount != 0
                    
            else { return }
            
            //save to portfolio
            if selectedGoldType != "انتخاب کنید" {
                if sold {
                    vm.portfolioDataService.addGold(name: selectedGoldType, amount: (amount * -1), note: noteText, date: vm.dateAdded)
                } else {
                    vm.portfolioDataService.addGold(name: selectedGoldType, amount: amount, note: noteText, date: vm.dateAdded)
                }
            } else {
                return
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
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchField = ""
    }
    
    private func saveBankInfo(name: String, code: String, note: String) {
        let convertedCode = Double(code)
        vm.portfolioDataService.addBank(name: name, code: convertedCode ?? 0, note: note)
    }
}

//MARK: PREVIEW
struct ManagePortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            ManagePortfolioView()
                .environmentObject(dev.homeVM)
                .preferredColorScheme(.dark)
        }
    }
}


