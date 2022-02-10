//TAB VIEW



//import SwiftUI
//
//struct HomeView: View {
//
//    init() {
//        UITableView.appearance().sectionFooterHeight = 0
//    }
//
//    @EnvironmentObject private var vm: HomeViewModel
//    @State private var showPrices: Bool = false
//    @State private var showPortfolioView: Bool = false
//    @State private var showSettingsView: Bool = false
//    @State private var selectedCoin: CoinModel? = nil
//    @State private var showDetailView: Bool = false
//    @State var showCurrencyChange: Bool = false
//
//    var body: some View {
//
//        TabView {
//            NavigationView {
//                mainScreenTwo
//                    .tabItem {
//                        Label("بازار", systemImage: "chart.xyaxis.line")
//                    }
//            }
//            NavigationView {
//                mainScreenOne
//                    .tabItem {
//                        Label("دارایی", systemImage: "chart.pie")
//                    }
//            }
//            NavigationView {
//                SettingsView()
//                    .tabItem {
//                        Label("تنظیمات", systemImage: "gear")
//            }
//
//                                }
//        }
//        .tabViewStyle(.automatic)
//
//    }
//}
//
////MARK: PREVIEW
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            HomeView()
//                .navigationBarHidden(true)
//        }
//        .preferredColorScheme(.dark)
//        .environmentObject(dev.homeVM)
//
//    }
//}
//
////MARK: EXTENSIONS
//extension HomeView {
//
//    private var mainScreenOne: some View {
//        ZStack {
//            //background layer
//            Color.theme.background
//                .ignoresSafeArea()
//                .sheet(isPresented: $showPortfolioView, content: {
//                    PortfolioView()
//                        .environmentObject(vm)
//                })
//                //content layer
//                VStack {
//
//                    //homeHeader
//                    portfolioList
//
//               // Spacer(minLength: 0)
//
//            }
//            .sheet(isPresented: $showSettingsView, content: {
//                SettingsView()
//            })
//            .background(
//                NavigationLink(
//                    destination: DetailLoadingView(coin: $selectedCoin),
//                    isActive: $showDetailView,
//                    label: { EmptyView() })
//                )
//        }
//    }
//
//    private var mainScreenTwo: some View {
//        ZStack {
//            //background layer
//            Color.theme.background
//                .ignoresSafeArea()
//                .sheet(isPresented: $showPortfolioView, content: {
//                    PortfolioView()
//                        .environmentObject(vm)
//                })
//            //content layer
//            VStack {
//
//              //  homeHeader
//                allCoinsList
//
//               // Spacer(minLength: 0)
//
//            }
//            .sheet(isPresented: $showSettingsView, content: {
//                SettingsView()
//            })
//            .background(
//                NavigationLink(
//                    destination: DetailLoadingView(coin: $selectedCoin),
//                    isActive: $showDetailView,
//                    label: { EmptyView() })
//                )
//            .navigationBarHidden(true)
//        }
//    }
//
//    //View: Header
//    private var homeHeader: some View {
//        HStack {
//            RecButtonView(iconName: showPrices ? "chart.pie" : "chart.xyaxis.line")
//                .onTapGesture {
//                    //withAnimation(.spring()) {
//                    showPrices.toggle()
//                    HapticManager.impact(style: .soft)
//                    //}
//                }
//
//            Spacer()
//
//            if vm.isLoading {
//                ProgressView()
//            } else if !vm.isLoading {
//                Image(systemName: showPrices ? "chart.line.uptrend.xyaxis.circle.fill" : "chart.pie.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 50, height: 50)
//                    .foregroundColor(Color.theme.accent)
//            }
//
//            Spacer()
//
//            RecButtonView(iconName: showPrices ? "gear" : "plus")
//                .onTapGesture {
//                    if !showPrices {
//                        showPortfolioView.toggle()
//                    } else if showPrices {
//                        showSettingsView.toggle()
//
//                    }
//                }
//        }
//        .padding(.horizontal)
//    }
//
//    //View: list of all coins
//    private var allCoinsList: some View {
//
//        List {
//            Section {
//                ForEach(vm.allCoins) { coin in
//                    CoinRowView(showHoldingColumn: false, showCurrencyChange: showCurrencyChange, coin: coin)
//                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 5))
//                        .onTapGesture {
//                            segue(coin: coin)
//                        }
//                }
//            } header: {
//
//                HomeStatsView(showPrices: $showPrices).onTapGesture {
//                }
//                SearchBarView(searchField: $vm.searchField)
//                columnTitle
//            }
//        }
//        .listStyle(.insetGrouped)
//        .refreshable {
//            vm.reloadData()
//        }
//    }
//
//    //View: list of portfolio
//    private var portfolioList: some View {
//        List {
//
//            Section {
//                ForEach(vm.portfolioCoins) { coin in
//                    CoinRowView(showHoldingColumn: true, showCurrencyChange: showCurrencyChange, coin: coin)
//                    //  .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
//                }
//
//            } header: {
//                HomeStatsView(showPrices: $showPrices)
//                SearchBarView(searchField: $vm.searchField)
//                columnTitle
//            }
//        }
//        .listStyle(.insetGrouped)
//        .refreshable {
//            vm.reloadData()
//
//        }
//
//    }
//
//    //Column Titles
//    private var columnTitle: some View {
//        HStack {
//            if showPrices{
//                HStack {
//                    Image(systemName: "number")
//                    Image(systemName: "chevron.down")
//                        .opacity((vm.sortOptions == .rank || vm.sortOptions == .rankReversed) ? 1.0 : 0.0)
//                        .rotationEffect(Angle(degrees: vm.sortOptions == .rank ? 0 : 180))
//                        .font(.caption2)
//                }
//                .onTapGesture {
//                    withAnimation {
//                        vm.sortOptions = vm.sortOptions == .rank ? .rankReversed : .rank
//                        HapticManager.impact(style: .soft)
//                    }
//                }
//
//
//                HStack {
//                    Image(systemName: "percent")
//                    Image(systemName: "chevron.down")
//                        .opacity((vm.sortOptions == .percentage || vm.sortOptions == .percentageReversed) ? 1.0 : 0.0)
//                        .rotationEffect(Angle(degrees: vm.sortOptions == .percentage ? 0 : 180))
//                        .font(.caption2)
//                }
//                .onTapGesture {
//                    withAnimation {
//                        vm.sortOptions = vm.sortOptions == .percentage ? .percentageReversed : .percentage
//                        HapticManager.impact(style: .soft)
//                    }
//                }
//
//                Spacer()
//
//                HStack {
//                    Text(showCurrencyChange ? "به ریال" :  "به دلار")
//                        .onTapGesture {
//                            showCurrencyChange.toggle()
//                        }
//                        .font(Font.custom("BYekan+", size: 14))
//                        .foregroundColor(Color.theme.SecondaryText)
//                }
//
//                HStack {
//
//                    Image(systemName: "chevron.down")
//                        .opacity((vm.sortOptions == .price || vm.sortOptions == .priceReversed) ? 1.0 : 0.0)
//                        .rotationEffect(Angle(degrees: vm.sortOptions == .price ? 0 : 180))
//                        .font(.caption2)
//                    Text("قیمت")
//
//                }
//                .onTapGesture {
//                    withAnimation {
//                        vm.sortOptions = vm.sortOptions == .price ? .priceReversed : .price
//                        HapticManager.impact(style: .soft)
//                    }
//                }
//
//            } else if !showPrices {
//                HStack {
//                    Image(systemName: "number")
//                    Image(systemName: "chevron.down")
//                        .opacity((vm.sortOptions == .rank || vm.sortOptions == .rankReversed) ? 1.0 : 0.0)
//                        .rotationEffect(Angle(degrees: vm.sortOptions == .rank ? 0 : 180))
//                        .font(.caption2)
//                }
//                .onTapGesture {
//                    withAnimation {
//                        vm.sortOptions = vm.sortOptions == .rank ? .rankReversed : .rank
//                        HapticManager.impact(style: .soft)
//                    }
//                }
//
//
//                HStack {
//                    Image(systemName: "percent")
//                    Image(systemName: "chevron.down")
//                        .opacity((vm.sortOptions == .percentage || vm.sortOptions == .percentageReversed) ? 1.0 : 0.0)
//                        .rotationEffect(Angle(degrees: vm.sortOptions == .percentage ? 0 : 180))
//                        .font(.caption2)
//                }
//                .onTapGesture {
//                    withAnimation {
//                        vm.sortOptions = vm.sortOptions == .percentage ? .percentageReversed : .percentage
//                        HapticManager.impact(style: .soft)
//                    }
//                }
//
//                Spacer()
//
//                HStack {
//                    Text(showCurrencyChange ? "به تومان" :  "به دلار")
//                        .onTapGesture {
//                            showCurrencyChange.toggle()
//                        }
//                        .font(Font.custom("BYekan+", size: 14))
//                        .foregroundColor(Color.theme.SecondaryText)
//                }
//
//
//                HStack {
//
//                    Image(systemName: "chevron.down")
//                        .opacity((vm.sortOptions == .holding || vm.sortOptions == .holdingReversed) ? 1.0 : 0.0)
//                        .rotationEffect(Angle(degrees: vm.sortOptions == .holding ? 0 : 180))
//                        .font(.caption2)
//                    Text("موجودی")
//
//                }
//                .onTapGesture {
//                    withAnimation {
//                        vm.sortOptions = vm.sortOptions == .holding ? .holdingReversed : .holding
//                        HapticManager.impact(style: .soft)
//                    }
//                }
//            }
//
//        }
//        .font(Font.custom("BYekan+", size: 14))
//        .foregroundColor(Color.theme.SecondaryText)
//        //        .lineLimit(1)
//        //        .minimumScaleFactor(0.1)
//    }
//
//    private func segue(coin: CoinModel) {
//        selectedCoin = coin
//        showDetailView.toggle()
//    }
//
//}
//
