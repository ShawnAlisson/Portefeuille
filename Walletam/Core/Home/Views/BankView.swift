//
//  BankView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 2/11/22.
//

import SwiftUI

struct BankView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = HomeViewModel()
    
    @State private var nameText: String = ""
    @FocusState private var nameIsFocused: Bool
    
    @State private var codeText: String = ""
    @FocusState private var codeIsFocused: Bool
    
    @State private var noteText: String = ""
    @FocusState private var noteIsFocused: Bool
    
    @State private var cardColor = Color.theme.SecondaryText
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack {
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        
                        HStack(spacing: -15) {
                            ForEach(vm.portfolioDataService.bankEntities) {item in
                                HStack {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Text("\(item.name ?? "")")
                                                    .font(Font.custom("BYekan+", size: 26))
                                                    .lineLimit(1).minimumScaleFactor(0.1)
                                            }.padding()
                                            Spacer()
                                            Text("\(item.code.asCreaditCardString())")
                                                .font(Font.custom("BYekan+", size: 24))
                                                .lineLimit(1).minimumScaleFactor(0.1)
                                                .padding()
                                            Spacer()
                                        }.frame(width: UIScreen.main.bounds.width * 0.88 , height: UIScreen.main.bounds.height * 0.26)
                                        
                                    

                                    }.padding().background(RoundedRectangle.init(cornerRadius: 15).opacity(0.5).padding())
                            }
                        }
                    }
                    
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
                        Spacer()
                        
                    }
                    
                    HStack {
                        Spacer()
                       ColorPicker("رنگ کارت:", selection: $cardColor, supportsOpacity: false)
                            .font(Font.custom("BYekan+", size: 16))
                            .environment(\.layoutDirection, .rightToLeft)
                            
                        Spacer()
                    }
                    
                    Text("افزودن").font(Font.custom("BYekan+", size: 22)).foregroundColor(Color.theme.background).padding().background(RoundedRectangle(cornerRadius: 15).foregroundColor((nameText.count > 0) ? Color.theme.accent : Color.theme.SecondaryText.opacity(0.5)).frame(width: UIScreen.main.bounds.width * 0.8, height: 60)).padding()
                        
                        .onTapGesture {
                            if (nameText.count > 0) {
                                saveBankInfo(name: nameText, code: codeText, note: noteText)
                                presentationMode.wrappedValue.dismiss()
                                
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
                    
                    
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("بستن") {
                            nameIsFocused = false
                            noteIsFocused = false
                            codeIsFocused = false
                        }
                        .font(Font.custom("BYekan", size: 18))
                    }
            })
            }
        }
    }
    
    func saveBankInfo(name: String, code: String, note: String) {
        let convertedCode = Double(code)
        vm.portfolioDataService.addBank(name: name, code: convertedCode ?? 0, note: note)
    }
}

struct BankView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack{
                BankView()
            }
        }
        
        
    }
}
