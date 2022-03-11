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
            
//            ZStack {
                List {
                    Section {
                        authenticationView
                        currencyView
                        
                        
                        
                        
                        //                    HStack {
                        //                        HStack {
                        //                            Text("کم به زیاد")
                        //                                .frame(width: 60)
                        //                                .padding().background(trendUpDown ? Color.theme.SecondaryText : Color.theme.accent).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                        //                                .onTapGesture {
                        //                                    trendUpDown = true
                        //                                }
                        //                            Text("زیاد به کم")
                        //                                .frame(width: 60)
                        //                                .padding().background(!trendUpDown ? Color.theme.SecondaryText : Color.theme.accent).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                        //                                .onTapGesture {
                        //                                    trendUpDown = false
                        //                                }
                        //
                        //                        }
                        //
                        //                        Spacer()
                        //
                        //                        Text("شیوه‌ی نمایش")
                        //                            .font(Font.custom("BYekan+", size: 14))
                        //
                        //
                        //                    }
                        
                        //                    HStack {
                        //
                        //
                        //                        Text("مقدار دارایی")
                        //                            .frame(width: 30)
                        //                            .padding().background(vm.sortOptions == .holding || vm.sortOptions == .holdingReversed ? Color.theme.accent : Color.theme.SecondaryText).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                        //                            .onTapGesture {
                        //
                        //                            }
                        //                        Text("تغییر در ۲۴ ساعت")
                        //                            .frame(width: 30)
                        //                            .padding().background(vm.showCurrencyChange ? Color.theme.accent : Color.theme.SecondaryText).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                        //                            .onTapGesture {
                        //                                vm.showCurrencyChange = true
                        //                            }
                        //                        Text("قیمت")
                        //                            .frame(width: 30)
                        //                            .padding().background(vm.showCurrencyChange ? Color.theme.accent : Color.theme.SecondaryText).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                        //                            .onTapGesture {
                        //                                vm.showCurrencyChange = true
                        //                            }
                        //                        Text("رتبه")
                        //                            .frame(width: 30)
                        //                            .padding().background(vm.showCurrencyChange ? Color.theme.accent : Color.theme.SecondaryText).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                        //                            .onTapGesture {
                        //                                vm.showCurrencyChange = true
                        //                            }
                        //
                        //                    }
                        
                    }
                    
                    Section {cardManageView} header: {
                        
                    } footer: {
                        
                        VStack {
                            SocialLinksView(websiteURL: "https://walletam.ir", githubURL: "", redditURL: "", telegramURL: "walletam.ir", twitterURL: "https://twitter.com/walletam.ir")
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
                                    Text("Version: 1.0").padding()
                                    Text("Made with ♥️")
                                }
                                .padding()
                                Spacer()
                            }
                                                }
                        
                    }
                }
                
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
                
            
                
//            }
            
            
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

    private var authenticationView: some View {
        HStack{
            switch authManager.biometryType {
            case .faceID:
                
                HStack {
                    Text(vm.authState ? "فعال" : "غیرفعال")
                        .frame(width: 50, height: 10)
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .foregroundColor(vm.authState ? Color.theme.green : Color.theme.red)
                        .font(Font.custom("BYekan+", size: 16))
                        .onTapGesture {
                            vm.authState.toggle()
                        }
                    Spacer()
                    Text("ورود با تشخیص چهره")
                        .font(Font.custom("BYekan+", size: 14))
                    Image(systemName: "faceid")
                }
                
            case .touchID:
                
                HStack {
                    Text(vm.authState ? "فعال" : "غیرفعال")
                        .frame(width: 50, height: 10)
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .foregroundColor(vm.authState ? Color.theme.green : Color.theme.red)
                        .font(Font.custom("BYekan+", size: 16))
                        .onTapGesture {
                            vm.authState.toggle()
                        }
                    Spacer()
                    Text("ورود با اثرانگشت")
                        .font(Font.custom("BYekan+", size: 14))
                    Image(systemName: "touchid")
                }
                
            default:
                
                HStack {
                    Text(vm.authState ? "فعال" : "غیرفعال")
                        .frame(width: 50, height: 10)
                        .padding()
                        .background(.ultraThinMaterial).cornerRadius(10)
                        .foregroundColor(vm.authState ? Color.theme.green : Color.theme.red)
                        .font(Font.custom("BYekan+", size: 16))
                        .onTapGesture {
                            vm.authState.toggle()
                        }
                    Spacer()
                    Text("ورود با رمز عبور")
                        .font(Font.custom("BYekan+", size: 14))
                    Image(systemName: "person.fill")
                }
            }
        }
        
    }
    
    private var currencyView: some View {
        HStack{
            HStack {
                Text("دلار")
                    .frame(width: 40, height: 10)
                    .padding()
                    .background(.ultraThinMaterial).cornerRadius(10)
                    .font(Font.custom("BYekan+", size: 16))
                    .foregroundColor(!vm.showCurrencyChange ? Color.theme.green : Color.theme.bwColor)
                    .onTapGesture {
                        vm.showCurrencyChange = false
                    }
                Text("تومان")
                    .frame(width: 40, height: 10)
                    .padding()
                    .background(.ultraThinMaterial).cornerRadius(10)
                    .font(Font.custom("BYekan+", size: 16))
                    .foregroundColor(vm.showCurrencyChange ? Color.theme.green : Color.theme.bwColor)
                
                
                    .onTapGesture {
                        vm.showCurrencyChange = true
                    }
            }
            
            Spacer()
            
            Text("واحد نمایش")
                .font(Font.custom("BYekan+", size: 14))
            Image(systemName: "bitcoinsign.square")
        }
    }
    
    
    private var cardManageView: some View {
        HStack {
            Spacer()
            Text("مدیریت حساب‌ها")
                .font(Font.custom("BYekan+", size: 14))
            Image(systemName: "creditcard")
        }
        .background(Color.theme.background.opacity(0.001))
        .onTapGesture {
            showBankView.toggle()
        }
        .sheet(isPresented: $showBankView, content: {
            ZStack {
                NavigationView {
                    ZStack {
                        List {
                            ForEach(vm.portfolioDataService.bankEntities, id: \.self) { item in
                                VStack{
                                    HStack{
                                        Spacer()
                                        Text("\(item.name ?? "")")
                                            .font(Font.custom("BYekan+", size: 16))
                                        
                                    }
                                    HStack{
                                        Text("\(item.code.asCreaditCardString())")
                                            .font(Font.custom("BYekan+", size: 14))
                                            .foregroundColor(Color.theme.SecondaryText)
                                        Spacer()
                                    }
                                }
                                .background(Color.theme.background.opacity(0.001))
                                .onTapGesture {
                                    cardSegue(bank: item)
                                }
            //                    if showBankEditView {
            //                        ZStack {
            //                            VStack {
            //                                HStack{Text("\(item.name ?? "")")}
            //                                HStack {
            //                                    TextField("", text: $nameText)
            //                                        .focused($nameIsFocused)
            //                                        .multilineTextAlignment(.leading)
            //                                        .font(Font.custom("BYekan", size: 18))
            //                                        .padding()
            //                                        .background(.ultraThinMaterial).cornerRadius(10)
            //                                        .onTapGesture {
            //                                            nameIsFocused = true
            //                                        }
            //
            //
            //                                    Text("نام حساب")
            //                                        .modifier(PersianFourteenSolo())
            //                                }
            //                                .padding()
            //
            //                                HStack {
            //                                    TextField("", text: $codeText)
            //                                        .limitInputLength(value: $codeText, length: 16)
            //                                        .focused($codeIsFocused)
            //                                        .multilineTextAlignment(.leading)
            //                                        .font(Font.custom("BYekan", size: 18))
            //                                        .keyboardType(.asciiCapableNumberPad)
            //                                        .padding()
            //                                        .background(.ultraThinMaterial).cornerRadius(10)
            //                                        .onTapGesture {
            //                                            codeIsFocused = true
            //                                        }
            //                                    Text("شماره کارت:")
            //                                        .modifier(PersianFourteenSolo())
            //                                }
            //                                .padding()
            //
            //                                HStack {
            //                                    TextField("", text: $noteText)
            //                                        .focused($noteIsFocused)
            //                                        .multilineTextAlignment(.leading)
            //                                        .font(Font.custom("BYekan", size: 18))
            //                                        .padding()
            //                                        .background(.ultraThinMaterial).cornerRadius(10)
            //                                        .onTapGesture {
            //                                            noteIsFocused = true
            //                                        }
            //                                    Text("یادداشت:")
            //                                        .modifier(PersianFourteenSolo())
            //                                }
            //                                .padding()
            //
            //                                PrimaryButton(image: "pencil", showImage: true, text: "ویرایش", disabled: false)
            //                                    .onTapGesture {
            //                                        let convertedCode = Double(codeText)
            //                                        vm.portfolioDataService.editBank(name: nameText, code: convertedCode ?? 0 , note: noteText, entity: item)
            //                                    }
            //                            }
            //                        }
            //                    }
                                    
                    
                            }
                            .onDelete(perform: remove)
                        }
                        .background(
                        NavigationLink(
                            destination: BankEditView(bank: $selectedBank),
                            isActive: $showBankDetailView,
                            label: { EmptyView() })
                    )
                        
                        
                    }
                    
                }
                .navigationViewStyle(StackNavigationViewStyle())
                
                CloseSheetButtonView(sheetToggle: $showBankView, disabled: showBankDetailView)
            }
            
        })
    }
    
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
