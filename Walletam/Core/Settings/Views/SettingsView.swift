//
//  SettingsView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/15/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = HomeViewModel()
    
    @StateObject var authManager = AuthenticationManager()
    @State private var trendUpDown: Bool = false
    @State private var showBankView: Bool = false
    @State private var showBankEditView: Bool = false
    
    @FocusState private var codeIsFocused: Bool
    @State private var codeText: String = ""
    @FocusState private var nameIsFocused: Bool
    @State private var nameText: String = ""
    @FocusState private var noteIsFocused: Bool
    @State private var noteText: String = ""
    
    @State private var selectedBank: BankEntity? = nil
    @State private var showBankDetailView: Bool = false
    
    var body: some View {
        
        NavigationView {
            List {
                Section {
                    authenticationView
                    currencyView
                }
                
                Section {
                    languageView
                    
                    //MARK: FUTURE
                    //                    dateSelectorView
                }
                
                //                Section {cardManageView} header: {
                //
                //                }
            
            //MARK: Footer
            footer: {
                VStack {
                    SocialLinksView(websiteURL: "https://portefeuille.ir", githubURL: "https://github.com/ShawnAlisson/Portefeuille", redditURL: "", telegramURL: "portefeuille_ir", twitterURL: "")
                    HStack {
                        Spacer()
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding()
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("made_with_love").padding()
                            Text("Version: 1.0 (Build 221112)")
                            
                        }
                        .padding()
                        Spacer()
                    }
                }
                
            }
            }
            .environment(\.layoutDirection, vm.translateState ? .leftToRight : .rightToLeft)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        HapticManager.impact(style: .soft)
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
            })
        }
    }
    
    private func remove(at offsets: IndexSet) {
        for index in offsets {
            let item = vm.portfolioDataService.bankEntities[index]
            vm.portfolioDataService.deleteBankEntity(entity: item)
            
        }
    }
}

//MARK: EXTENSIONS
//MARK: VIEWS
extension SettingsView {
    
    //MARK: Auth Setting
    private var authenticationView: some View {
        HStack{
            switch authManager.biometryType {
            case .faceID:
                
                HStack {
                    Image(systemName: "faceid")
                    Text("login_with_faceid")
                        .font(Font.custom("BYekan+", size: 14))
                    Spacer()
                    Text(vm.authState ? "active" : "deactive")
                        .frame(height: 10)
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .foregroundColor(vm.authState ? Color.theme.green : Color.theme.red)
                        .font(Font.custom("BYekan+", size: 16))
                        .onTapGesture {
                            vm.authState.toggle()
                        }
                    
                }
                
            case .touchID:
                
                HStack {
                    Image(systemName: "touchid")
                    Text("login_with_touchid")
                        .font(Font.custom("BYekan+", size: 14))
                    
                    Spacer()
                    Text(vm.authState ? "active" : "deactive")
                        .frame(height: 10)
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .foregroundColor(vm.authState ? Color.theme.green : Color.theme.red)
                        .font(Font.custom("BYekan+", size: 16))
                        .onTapGesture {
                            vm.authState.toggle()
                        }
                    
                }
                
            default:
                
                HStack {
                    Image(systemName: "person.fill")
                    Text("login_with_password")
                        .font(Font.custom("BYekan+", size: 14))
                    Spacer()
                    Text(vm.authState ? "active" : "deactive")
                        .frame(width: 50, height: 10)
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .foregroundColor(vm.authState ? Color.theme.green : Color.theme.red)
                        .font(Font.custom("BYekan+", size: 16))
                        .onTapGesture {
                            vm.authState.toggle()
                        }
                    
                }
            }
        }
        
    }
    
    //MARK: Language Setting
    private var languageView: some View {
        HStack{
            HStack {
                Image(systemName: "globe")
                Text("language")
                    .font(Font.custom("BYekan+", size: 14))
                
                Spacer()
                Text("english")
                    .frame(height: 10)
                    .padding()
                    .background(.ultraThinMaterial).cornerRadius(10)
                    .font(Font.custom("BYekan+", size: 16))
                    .foregroundColor(vm.translateState ? Color.theme.green : Color.theme.bwColor)
                    .onTapGesture {
                        vm.translateState = true
                        presentationMode.wrappedValue.dismiss()
                        HapticManager.impact(style: .soft)
                    }
                Text("persian")
                    .frame(height: 10)
                    .padding()
                    .background(.ultraThinMaterial).cornerRadius(10)
                    .font(Font.custom("BYekan+", size: 16))
                    .foregroundColor(!vm.translateState ? Color.theme.green : Color.theme.bwColor)
                
                
                    .onTapGesture {
                        vm.translateState = false
                        presentationMode.wrappedValue.dismiss()
                        HapticManager.impact(style: .soft)
                    }
            }
            
        }
    }
    
    
    
    //MARK: Currency Setting
    private var currencyView: some View {
        HStack{
            HStack {
                
                Image(systemName: "bitcoinsign.square")
                Text("currency_view")
                    .font(Font.custom("BYekan+", size: 14))
                
                Spacer()
                Text("dollar")
                    .frame(height: 10)
                    .padding()
                    .background(.ultraThinMaterial).cornerRadius(10)
                    .font(Font.custom("BYekan+", size: 16))
                    .foregroundColor(!vm.showCurrencyChange ? Color.theme.green : Color.theme.bwColor)
                    .onTapGesture {
                        vm.showCurrencyChange = false
                    }
                Text("toman_sign")
                    .frame(height: 10)
                    .padding()
                    .background(.ultraThinMaterial).cornerRadius(10)
                    .font(Font.custom("BYekan+", size: 16))
                    .foregroundColor(vm.showCurrencyChange ? Color.theme.green : Color.theme.bwColor)
                
                
                    .onTapGesture {
                        vm.showCurrencyChange = true
                    }
            }
            
            
        }
    }
    
 
//MARK: FUTURE
//    private var cardManageView: some View {
//        HStack {
//            Spacer()
//            Text("account_manage")
//                .font(Font.custom("BYekan+", size: 14))
//            Image(systemName: "creditcard")
//        }
//        .background(Color.theme.background.opacity(0.001))
//        .onTapGesture {
//            showBankView.toggle()
//        }
//        .sheet(isPresented: $showBankView, content: {
//            ZStack {
//                NavigationView {
//                    ZStack {
//                        List {
//                            ForEach(vm.portfolioDataService.bankEntities, id: \.self) { item in
//                                VStack{
//                                    HStack{
//                                        Spacer()
//                                        Text("\(item.name ?? "")")
//                                            .font(Font.custom("BYekan+", size: 16))
//
//                                    }
//                                    HStack{
//                                        Text("\(item.code.asCreaditCardString())")
//                                            .font(Font.custom("BYekan+", size: 14))
//                                            .foregroundColor(Color.theme.SecondaryText)
//                                        Spacer()
//                                    }
//                                }
//                                .background(Color.theme.background.opacity(0.001))
//                                .onTapGesture {
//                                    cardSegue(bank: item)
//                                }
//                            }
//                            .onDelete(perform: remove)
//                        }
//                        .background(
//                            NavigationLink(
//                                destination: BankEditView(bank: $selectedBank),
//                                isActive: $showBankDetailView,
//                                label: { EmptyView() })
//                        )
//                    }
//                    .navigationTitle("")
//
//                }
//                .navigationViewStyle(StackNavigationViewStyle())
//
//                CloseSheetButtonView(sheetToggle: $showBankView, disabled: showBankDetailView)
//            }
//
//        })
//    }
    
    //MARK: Calculator Setting
//    private var dateSelectorView: some View {
//        HStack{
//            HStack {
//                Text("gregorian")
//                    .frame(height: 10)
//                    .padding()
//                    .background(.ultraThinMaterial).cornerRadius(10)
//                    .font(Font.custom("BYekan+", size: 16))
//                    .foregroundColor(vm.calendarState ? Color.theme.green : Color.theme.bwColor)
//                    .onTapGesture {
//                        vm.calendarState = true
//                        presentationMode.wrappedValue.dismiss()
//                        HapticManager.impact(style: .soft)
//                    }
//                Text("shamsi")
//                    .frame(height: 10)
//                    .padding()
//                    .background(.ultraThinMaterial).cornerRadius(10)
//                    .font(Font.custom("BYekan+", size: 16))
//                    .foregroundColor(!vm.calendarState ? Color.theme.green : Color.theme.bwColor)
//
//
//                    .onTapGesture {
//                        vm.calendarState = false
//                        presentationMode.wrappedValue.dismiss()
//                        HapticManager.impact(style: .soft)
//                    }
//            }
//            Spacer()
//
//            Text("calendar")
//                .font(Font.custom("BYekan+", size: 14))
//            Image(systemName: "calendar")
//        }
//    }
    
    //MARK: FUNCTIONS
    private func cardSegue(bank: BankEntity) {
        selectedBank = bank
        showBankDetailView.toggle()
        print(showBankDetailView.description)
    }
}

//MARK: PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            
            SettingsView()
            
                .preferredColorScheme(.dark)
        }
    }
}
