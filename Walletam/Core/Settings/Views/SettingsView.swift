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
    
    var body: some View {
        
        NavigationView {
            List {
                Section {
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
                
                Section {
                    HStack {
                        Spacer()
                        Text("مدیریت حساب‌ها")
                            .font(Font.custom("BYekan+", size: 14))
                        Image(systemName: "creditcard")
                    }.onTapGesture {
                        showBankView.toggle()
                    }.sheet(isPresented: $showBankView, content: {
                        List {
                            ForEach(vm.portfolioDataService.bankEntities) { item in
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
                            }
                            .onDelete(perform: remove)
                        }
                    })
                } header: {
                                        
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
        
        }
    }
    
    private func remove(at offsets: IndexSet) {
        for index in offsets {
            let item = vm.portfolioDataService.bankEntities[index]
            vm.portfolioDataService.deleteBankEntity(entity: item)
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}
