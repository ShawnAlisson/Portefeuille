//
//  BankView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 4/21/22.
//

import SwiftUI

struct BankView: View {
    
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var selectedAccount: String = "بدون دسته‌بندی"
    
    @FocusState private var nameIsFocused: Bool
    @FocusState private var codeIsFocused: Bool
    @FocusState private var noteIsFocusedForBank: Bool
    
    @State private var nameText: String = ""
    @State private var codeText: String = ""
    @State private var noteTextForBank: String = ""
    
    @State private var showAddBankView: Bool = false
    
    private var mn = ManagePortfolioView()
    
    
    var body: some View {
        ZStack {
            if (mn.vm.portfolioDataService.bankEntities.isEmpty && !showAddBankView) {
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
//            CloseSheetButtonView(sheetToggle: $showBankSelectionView, disabled: showAddBankView)
        }
    }
}

//MARK: EXTENSIONS
extension BankView {
    
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
                            print("clicked")
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
                        .focused($noteIsFocusedForBank)
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
                        saveBankInfo(name: nameText, code: codeText, note: noteTextForBank)
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
                    ForEach(mn.vm.portfolioDataService.bankEntities) { item in
                        CardVerticalView(code: item.code, name: item.name)
                            .onTapGesture {
//                                selectedAccount = item.name ?? ""
                                withAnimation{
//                                    showBankSelectionView.toggle()
                                }
                            }
                    }
                }
            }
            .padding()
            
            Spacer()
            
        }
        .onAppear(perform: mn.vm.portfolioDataService.applyChanges)
    }
    
    private func saveBankInfo(name: String, code: String, note: String) {
        let convertedCode = Double(code)
        mn.vm.portfolioDataService.addBank(name: name, code: convertedCode ?? 0, note: note)
    }

}

struct BankView_Previews: PreviewProvider {
    static var previews: some View {
        BankView()
           
    }
}
