//
//  HomeView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/5/22.
//

import SwiftUI

struct HomeView: View {
    
    //init for reducing space between rows
    init() {
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    @EnvironmentObject private var vm: HomeViewModel
    @StateObject var authManager = AuthenticationManager()
    
    @State private var showPrices: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var showSettingsView: Bool = false
    @State private var showDetailView: Bool = false
    @State private var showTranView: Bool = false
    @State private var showIRTransView: Bool = false
    @State private var showGoldView: Bool = false
    @State private var animationAmount = 0.3
    
    @State private var selectedCoin: CoinModel? = nil
    @FocusState private var searchIsFocused: Bool
    
    var body: some View {
        
        ZStack {
            //background layer
            Color.theme.background
                .ignoresSafeArea()
            
                .sheet(isPresented: $showPortfolioView, content: {
                    ManagePortfolioView()
                        .environmentObject(vm)
                        .onAppear(perform: {
                            self.vm.dateAdded = Date.now
                        })
                        .onDisappear(perform: vm.portfolioDataService.getPortfolio)
                })
            
            //content layer
            VStack {
                
                //Prices View
                if showPrices {
                    allCoinsList
                }
                
                //Portfolio View
                if !showPrices {
                    
                    ZStack(alignment: .top) {
                        
                        //show startup screen if portfolio is empty
                        if vm.portfolioDataService.savedEntities.isEmpty && vm.searchField.isEmpty && vm.portfolioDataService.irEntities.isEmpty {emptyPortfolioList } else if vm.portfolioCoins.isEmpty && vm.portfolioDataService.irEntities.isEmpty {loadingPortfolioList} else {portfolioList}
                    }
                }
                
                Spacer(minLength: 0)
            }
            .redacted(when: vm.isLoading)
            .opacity(animationAmount)
            .animation(Animation
                .easeInOut(duration: 1)
                .repeatForever(autoreverses: true), value: animationAmount)
            .onAppear { animationAmount = 0.8 }
            
            //MARK: FUTURE
            //                        .background(NavigationLink(
            //                            destination: GoldView(),
            //                            isActive: $showGoldView,
            //                            label: { EmptyView() }))
            
            //Settings View Sheet
            .sheet(isPresented: $showSettingsView, content: {
                SettingsView()
            })
            
            //Navigation Link for Detail View
            .background(
                NavigationLink(
                    destination: DetailLoadingView(coin: $selectedCoin),
                    isActive: $showDetailView,
                    label: { EmptyView() }).opacity(0)
            )
            
            //Custom Tab Bar
            VStack{
                Spacer()
                customTabBar
                    .padding(.bottom, 5)
            }
            .ignoresSafeArea()
            .unredacted()
            
            //Navigation Link for Transaction View
            .background(
                NavigationLink(
                    destination: TransactionLoadingView(coin: $selectedCoin),
                    isActive: $showTranView,
                    label: { EmptyView() }).opacity(0))
            
            
        }
        .background(
            NavigationLink(
                destination: TomanTransactionView(),
                isActive: $showIRTransView,
                label: { EmptyView() }).opacity(0)
        )
        .toolbar(content: {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("close") {
                    searchIsFocused = false
                }
                .font(Font.custom("BYekan", size: 18))
            }
        })
    }
}

//MARK: PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
        
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
        .environment(\.locale, .init(identifier: "fa"))
        
        
    }
}

//MARK: EXTENSIONS
extension HomeView {
    
    //MARK: Prices View
    private var allCoinsList: some View {
        List {
            Section {
                if vm.allCoins.isEmpty {
                    
                    ForEach(0..<25) { index in
                        HStack {
                            HStack{
                                Image(systemName: "bitcoinsign.circle.fill")
                                    .resizable().scaledToFit().frame(width: 35, height: 35)
                                VStack{
                                    Text("Bitcoin")
                                    HStack {
                                        Text("12 %")
                                        Text("12 %")
                                    }
                                }
                            }
                            Spacer()
                            VStack {
                                Text("(\(index)")
                                Text("12 %")
                            }
                        }
                        
                    }
                    .redacted(reason: .placeholder)
                    .opacity(animationAmount)
                    .animation(Animation
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true), value: animationAmount)
                    .onAppear { animationAmount = 0.8 }
                    
                } else {
                    ForEach(vm.allCoins) { coin in
                        CoinRowView(showHoldingColumn: false, showCurrencyChange: vm.showCurrencyChange, coin: coin)
                            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 5))
                            .onTapGesture {
                                segue(coin: coin)
                            }
                            .onLongPressGesture {
                                UIPasteboard.general.string = "\(coin.currentPrice)"
                                HapticManager.impact(style: .soft)
                            }
                    }
                    
                }
                //MARK: Header
            } header: {
                
                
                //MARK: Stats and Search
                HomeStatsView(showPrices: $showPrices)
                SearchBarView(searchField: $vm.searchField)
                    .focused($searchIsFocused)
                    .onTapGesture {
                        searchIsFocused = true
                    }
                
                columnTitle
            }
        }
        .listStyle(.insetGrouped)
#if !targetEnvironment(macCatalyst)
        .refreshable {
            vm.reloadData()
        }
#endif
    }
    
    //MARK: Portefeuille View
    private var portfolioList: some View {
        
        List {
            Section {
                
                if vm.portfolioCoins.isEmpty && !vm.portfolioDataService.savedEntities.isEmpty {
                    
                    let numDum = vm.portfolioDataService.savedEntities.count
                    
                    ForEach(0..<numDum, id: \.self) { index in
                        HStack {
                            HStack{
                                Image(systemName: "bitcoinsign.circle.fill")
                                    .resizable().scaledToFit().frame(width: 35, height: 35)
                                VStack{
                                    Text("Bitcoin")
                                    HStack {
                                        Text("12 %")
                                        Text("12 %")
                                    }
                                }
                            }
                            Spacer()
                            VStack {
                                Text("(\(index)")
                                Text("12 %")
                            }
                        }
                    }
                    .redacted(reason: .placeholder)
                    .opacity(animationAmount)
                    .animation(Animation
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true), value: animationAmount)
                    .onAppear { animationAmount = 0.8 }
                    
                } else {
                    
                    ForEach(vm.portfolioCoins) { coin in
                        CoinRowView(showHoldingColumn: true, showCurrencyChange: vm.showCurrencyChange, coin: coin)
                        //  .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .onTapGesture {
                                segueTran(coin: coin)
                            }
                            .onLongPressGesture {
                                UIPasteboard.general.string = String(coin.currentHoldings ?? 0)
                                HapticManager.impact(style: .soft)
                            }
                        
                    }
                    .onDelete(perform: remove)
                }
            }
            //MARK: Header
        header: {
            HomeStatsView(showPrices: $showPrices)
            //            SearchBarView(searchField: $vm.searchField)
            columnTitle
        }
            Section {
                if !vm.portfolioDataService.irEntities.isEmpty {
                    tomanPortfolioView
                }
            }
            
            //Future UPDATE
            //            Section {
            //                if !vm.portfolioDataService.goldEntities.isEmpty {
            //                goldPortfolioView
            //                }
            //            }
            
        footer: {
            Text("").frame(height: 50)
        }
        }
        //        .id(vm.refreshingID)
        .listStyle(.insetGrouped)
        .onAppear(perform: vm.portfolioDataService.applyChanges)
        .onAppear(perform: vm.irAmountCalc)
#if !targetEnvironment(macCatalyst)
        .refreshable {
            vm.reloadData()
        }
#endif
    }
    
    //MARK: FUTURE
    //    private var goldPortfolioView: some View {
    //        HStack{
    //            HStack {
    //                Image(systemName: "circlebadge.2.fill").resizable().scaledToFit().frame(width: 45, height: 45).foregroundColor(Color.yellow)
    //
    //                Text("سکه و طلا").font(Font.custom("BYekan+", size: 16))
    //            }
    //
    //            Spacer()
    //
    //            HStack {
    //                Text("helo")
    //            }
    //
    //        }.background(Color.theme.background.opacity(0.001))
    //            .onTapGesture {
    //                segueGold()
    //            }
    //    }
    
    //MARK: Toman Section View
    private var tomanPortfolioView: some View {
        HStack{
            HStack {
                Image(systemName: "creditcard.circle.fill").resizable().scaledToFit().frame(width: 45, height: 45).foregroundColor(Color.theme.green)
                Text("toman_sign").font(Font.custom("BYekan+", size: 16))
            }
            
            Spacer()
            
            let newTethPrice = ((vm.tethPrice ?? "") as NSString).doubleValue
            let newPrice = (vm.irPrice ?? 0) / newTethPrice
            
            VStack(alignment: .trailing){
                Text(vm.translateState ? "\(vm.irPrice?.asTomanWithTwoDecimalsEng() ?? "")" : "\(vm.irPrice?.asTomanWith2Decimals() ?? "")")
                    .font(Font.custom("BYekan+", size: 16))
                if newPrice.isInfinite {
                    HStack{
                        Text("$۰.۰۱")
                            .font(Font.custom("BYekan+", size: 14)).foregroundColor(Color.theme.SecondaryText)
                    }
                    .redacted(reason: .placeholder)
                    .opacity(animationAmount)
                    .animation(Animation
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true), value: animationAmount)
                    .onAppear { animationAmount = 0.8 }
                } else {
                    Text(vm.translateState ? "\( (newPrice*10).asDollarWithTwoDecimalsEng() )" : "\( (newPrice*10).asCurrencyWith2Decimals() )")
                        .font(Font.custom("BYekan+", size: 14)).foregroundColor(Color.theme.SecondaryText)
                }
            }
        }.background(Color.theme.background.opacity(0.001))
            .onTapGesture {
                segueIRTran()
            }
            .onLongPressGesture {
                UIPasteboard.general.string = "\(vm.irPrice ?? 0)"
                HapticManager.impact(style: .soft)
            }
    }
    
    //MARK: Empty Welcome View
    private var emptyPortfolioList: some View {
        VStack {
            Spacer()
            Image(systemName: "menucard.fill")
                .resizable()
                .scaledToFit().frame(width: 200, height: 200)
                .foregroundColor(Color.theme.SecondaryText.opacity(0.5))
            Text("intro_text")
                .multilineTextAlignment(.center)
                .font(Font.custom("BYekan+", size: 22))
                .padding()
            
            Spacer()
        }
        .unredacted()
    }
    
    //MARK: Loading View
    private var loadingPortfolioList: some View {
        List {
            Section {
            }
        header: {
            VStack{
                ForEach(100000..<100004) { index in
                    HStack{
                        Text("Test").foregroundColor(Color.theme.green)
                        Spacer()
                        Text("Test").foregroundColor(Color.theme.red)
                        
                    }
                    
                }.padding()
            }.background(
                .ultraThinMaterial).cornerRadius(15).frame(height: 100)
            
            columnTitle.padding()
        }.redacted(reason: .placeholder)
            
            
            
            Section {
                if !vm.portfolioDataService.irEntities.isEmpty {
                    tomanPortfolioView
                }
            }
        footer: {
            Text("").frame(height: 50)
        }
        }
        .listStyle(.insetGrouped)
#if !targetEnvironment(macCatalyst)
        .refreshable {
            vm.reloadData()
        }
#endif
    }
    
    
    //MARK: Tab Bar
    private var customTabBar: some View {
        ZStack {
            //            RoundedRectangle(cornerRadius: 20).fill(Color.theme.background.opacity(0.9))
            //                .shadow(color: Color.theme.shadowColor.opacity(0.6), radius: 25, x: 0, y: 0)
            //                .frame(width: UIScreen.main.bounds.width / 1.2, height: 52, alignment: .center)
            //                .padding()
            
            HStack{
                HStack {
                    Image(systemName: "chart.xyaxis.line")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(showPrices ? Color.theme.accent : Color.theme.reverseBackgroundColor)
                        .frame(width: 30, height: 30)
                        .padding(.horizontal)
                        .onTapGesture {
                            //withAnimation(.spring()) {
                            vm.searchField = ""
                            showPrices = true
                            HapticManager.impact(style: .soft)
                            //}
                        }
                    Spacer()
                    Image(systemName: "menucard")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(!showPrices && !showSettingsView ?  Color.theme.accent : Color.theme.reverseBackgroundColor)
                        .frame(width: 28, height: 28)
                        .padding(.horizontal)
                        .onTapGesture {
                            //withAnimation(.spring()) {
                            vm.searchField = ""
                            showPrices = false
                            HapticManager.impact(style: .soft)
                            //}
                        }
                    Spacer()
                    
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(showPortfolioView ? Color.theme.green : Color.theme.reverseBackgroundColor)
                        .frame(width: 28, height: 28)
                        .padding(.horizontal)
                        .onTapGesture {
                            vm.searchField = ""
                            showPortfolioView.toggle()
                            HapticManager.impact(style: .soft)
                        }
                    
                    Spacer()
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(showSettingsView ? Color.theme.accent : Color.theme.reverseBackgroundColor)
                        .frame(width: 28, height: 28)
                        .padding(.horizontal, 25)
                        .onTapGesture {
                            //withAnimation(.spring()) {
                            vm.searchField = ""
                            showSettingsView = true
                            HapticManager.impact(style: .soft)
                            //}
                        }
                    
                }
                .padding()
                //                .frame(width: UIScreen.main.bounds.width / 1.2, height: 52, alignment: .center)
            }
        }.background(.ultraThinMaterial).cornerRadius(30).shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 0, x: 2, y: 2)
        //                        .frame(width: UIScreen.main.bounds.width / 1.2, height: 52, alignment: .center)
            .padding()
    }
    
    //MARK: Column Titles
    private var columnTitle: some View {
        HStack {
            if showPrices{
                HStack {
                    Image(systemName: "number")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOptions == .rank || vm.sortOptions == .rankReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOptions == .rank ? 0 : 180))
                        .font(.caption2)
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOptions = vm.sortOptions == .rank ? .rankReversed : .rank
                        HapticManager.impact(style: .soft)
                    }
                }
                
                
                HStack {
                    Image(systemName: "percent")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOptions == .percentage || vm.sortOptions == .percentageReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOptions == .percentage ? 0 : 180))
                        .font(.caption2)
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOptions = vm.sortOptions == .percentage ? .percentageReversed : .percentage
                        HapticManager.impact(style: .soft)
                    }
                }
                
                Spacer()
                
                HStack {
                    Text(vm.showCurrencyChange ? "toman_sign" : "dollar")
                        .onTapGesture {
                            vm.showCurrencyChange.toggle()
                            HapticManager.impact(style: .soft)
                        }
                        .font(Font.custom("BYekan+", size: 14))
                        .foregroundColor(Color.theme.SecondaryText)
                }
                
                HStack {
                    
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOptions == .price || vm.sortOptions == .priceReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOptions == .price ? 0 : 180))
                        .font(.caption2)
                    Text("price")
                    
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOptions = vm.sortOptions == .price ? .priceReversed : .price
                        HapticManager.impact(style: .soft)
                    }
                }
                
            } else if !showPrices {
                HStack {
                    Image(systemName: "number")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOptions == .rank || vm.sortOptions == .rankReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOptions == .rank ? 0 : 180))
                        .font(.caption2)
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOptions = vm.sortOptions == .rank ? .rankReversed : .rank
                        HapticManager.impact(style: .soft)
                    }
                }
                
                
                HStack {
                    Image(systemName: "percent")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOptions == .percentage || vm.sortOptions == .percentageReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOptions == .percentage ? 0 : 180))
                        .font(.caption2)
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOptions = vm.sortOptions == .percentage ? .percentageReversed : .percentage
                        HapticManager.impact(style: .soft)
                    }
                }
                
                Spacer()
                
                
                HStack {
                    Text(vm.showCurrencyChange ? "toman_sign" :  "dollar")
                        .onTapGesture {
                            vm.showCurrencyChange.toggle()
                            HapticManager.impact(style: .soft)
                        }
                        .font(Font.custom("BYekan+", size: 14))
                        .foregroundColor(Color.theme.SecondaryText)
                }
                
                
                HStack {
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOptions == .holding || vm.sortOptions == .holdingReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOptions == .holding ? 0 : 180))
                        .font(.caption2)
                    Text("holding")
                    
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOptions = vm.sortOptions == .holding ? .holdingReversed : .holding
                        HapticManager.impact(style: .soft)
                    }
                }
            }
            
        }
        .font(Font.custom("BYekan+", size: 14))
        .foregroundColor(Color.theme.SecondaryText)
        //        .lineLimit(1)
        //        .minimumScaleFactor(0.1)
    }
    
    
    
    
    //MARK: FUNCTIONS
    
    //MARK: Delete Function
    func remove(at offsets: IndexSet) {
        for index in offsets {
            let coin = vm.portfolioCoins[index]
            vm.portfolioDataService.delete(coin: coin)
        }
    }
    
    //MARK: Navigation to Detail Function
    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    //MARK: Navigate to Transaction Function
    private func segueTran(coin: CoinModel) {
        selectedCoin = coin
        showTranView.toggle()
    }
    
    //MARK: Navigate to Toman Transaction Function
    private func segueIRTran() {
        showIRTransView.toggle()
    }
    
    //MARK: FUTURE
    //    private func segueGold() {
    //        showGoldView.toggle()
    //    }
}
extension View {
    @ViewBuilder
    func redacted(when condition: Bool) -> some View {
        if !condition {
            unredacted()
        } else {
            redacted(reason: .placeholder)
        }
    }
}
