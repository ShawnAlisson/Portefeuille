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
    
    var body: some View {
        NavigationView {
            VStack {
                
            
                ScrollView(.horizontal, showsIndicators: false){
                    
                    HStack {
                        ForEach(vm.portfolioDataService.bankEntities) {item in
                                HStack {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Text("\(item.name ?? "")")
                                                .font(Font.custom("BYekan+", size: 26))
                                        }.padding()
                                        Spacer()
                                        Text("\(item.code.asCreaditCardString())")
                                            .font(Font.custom("BYekan+", size: 24))
                                            .lineLimit(1)
                                        Spacer()
                                    }.frame(width: 350 , height: 200)
                                    
                                

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
                
                Text("افزودن").font(Font.custom("BYekan+", size: 22)).padding().background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color.theme.accent).frame(width: UIScreen.main.bounds.width * 0.8))
                    .onTapGesture {
                        saveBankInfo(name: nameText, code: codeText, note: noteText)
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
