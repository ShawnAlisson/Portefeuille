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
    @State private var trendUpDown: Bool = false
    
    var body: some View {
        
        NavigationView {
            List {
                Section {
                    HStack{
                        
                        HStack {
                            Text("دلار")
                                .frame(width: 40, height: 10)
                                .padding()
                                .background(.ultraThinMaterial).cornerRadius(10)
                                .font(Font.custom("BYekan+", size: 16))
                                .foregroundColor(!vm.showCurrencyChange ? Color.theme.accent : Color.theme.shadowColor)
                                .onTapGesture {
                                    vm.showCurrencyChange = false
                                }
                            Text("تومان")
                                .frame(width: 40, height: 10)
                                .padding()
                                .background(.ultraThinMaterial).cornerRadius(10)
                                .font(Font.custom("BYekan+", size: 16))
                                .foregroundColor(vm.showCurrencyChange ? Color.theme.accent : Color.theme.shadowColor)
                                
                                
                                .onTapGesture {
                                    vm.showCurrencyChange = true
                                }
                        }
                        
                        
                        
                        Spacer()
                        
                        Text("واحد نمایش")
                            .font(Font.custom("BYekan+", size: 14))
                        
                        
                    }
                    
                    
                    
                    HStack {
                        HStack {
                            Text("کم به زیاد")
                                .frame(width: 60)
                                .padding().background(trendUpDown ? Color.theme.SecondaryText : Color.theme.accent).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                                .onTapGesture {
                                    trendUpDown = true
                                }
                            Text("زیاد به کم")
                                .frame(width: 60)
                                .padding().background(!trendUpDown ? Color.theme.SecondaryText : Color.theme.accent).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                                .onTapGesture {
                                    trendUpDown = false
                                }
                            
                        }
                        
                        Spacer()
                        
                        Text("شیوه‌ی نمایش")
                            .font(Font.custom("BYekan+", size: 14))
                     
                    
                    }
                    
                    HStack {
                        
                        
                        Text("مقدار دارایی")
                            .frame(width: 30)
                            .padding().background(vm.sortOptions == .holding || vm.sortOptions == .holdingReversed ? Color.theme.accent : Color.theme.SecondaryText).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                            .onTapGesture {
                                
                            }
                        Text("تغییر در ۲۴ ساعت")
                            .frame(width: 30)
                            .padding().background(vm.showCurrencyChange ? Color.theme.accent : Color.theme.SecondaryText).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                            .onTapGesture {
                                vm.showCurrencyChange = true
                            }
                        Text("قیمت")
                            .frame(width: 30)
                            .padding().background(vm.showCurrencyChange ? Color.theme.accent : Color.theme.SecondaryText).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                            .onTapGesture {
                                vm.showCurrencyChange = true
                            }
                        Text("رتبه")
                            .frame(width: 30)
                            .padding().background(vm.showCurrencyChange ? Color.theme.accent : Color.theme.SecondaryText).cornerRadius(15).font(Font.custom("BYekan+", size: 14))
                            .onTapGesture {
                                vm.showCurrencyChange = true
                            }
                        
                    }
                    
                } header: {
                    HStack {
                        Spacer()
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding()
                        Spacer()
                    }
                    
                } footer: {
                    
                    VStack {
                        SocialLinksView(websiteURL: "https://walletam.ir", githubURL: "", redditURL: "", telegramURL: "walletam.ir", twitterURL: "https://twitter.com/walletam.ir")
                        
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
