//
//  BankEditView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 3/2/22.
//

import SwiftUI

struct BankEditView: View {
    
    @ObservedObject var vm = HomeViewModel()
    
    @Binding var bank: BankEntity?
    
    @State private var bankNameText: String = ""
    @FocusState private var bankNameIsFocused: Bool
    @State private var bankCodeText: String = ""
    @FocusState private var bankCodeIsFocused: Bool
    @State private var bankNoteText: String = ""
    @FocusState private var bankNoteIsFocused: Bool
    
    
    @State private var showEditView: Bool = false
    
    var body: some View {
        List{
            Section {
                HStack{
                    if showEditView {
                        HStack {
                            TextField("", text: $bankNameText)
                                .focused($bankNameIsFocused)
                                .multilineTextAlignment(.leading)
                                .font(Font.custom("BYekan", size: 14))
                                .padding(10)
                                .background(.ultraThinMaterial).cornerRadius(10)
                                .onTapGesture {
                                    bankNameIsFocused = true
                                }
                                .onAppear { self.bankNameText = bank?.name ?? "" }
                        }
                        
                    } else {
                        Text("\(bank?.name ?? "")")
                    }
                    Spacer()
                    Text("نام حساب:")
                }
                
                HStack{
                    if showEditView {
                        HStack {
                            TextField("", text: $bankCodeText)
                                .focused($bankCodeIsFocused)
                                .multilineTextAlignment(.leading)
                                .font(Font.custom("BYekan", size: 14))
                                .padding(10)
                                .background(.ultraThinMaterial).cornerRadius(10)
                                .onTapGesture {
                                    bankCodeIsFocused = true
                                }
                                .onAppear { self.bankCodeText = bank?.code.asEngNumberString() ?? "" }
                        }
                        
                    } else {
                        Text("\(bank?.code.asCreaditCardString() ?? "")")
                    }
                    Spacer()
                    Text("شماره حساب:")
                }
                
                HStack{
                    if showEditView {
                        HStack {
                            TextField("", text: $bankNoteText)
                                .focused($bankNoteIsFocused)
                                .multilineTextAlignment(.leading)
                                .font(Font.custom("BYekan", size: 14))
                                .padding(10)
                                .background(.ultraThinMaterial).cornerRadius(10)
                                .onTapGesture {
                                    bankNoteIsFocused = true
                                }
                                .onAppear { self.bankNoteText = bank?.note ?? "" }
                        }
                        
                    } else {
                        Text("\(bank?.note ?? "")")
                    }
                    Spacer()
                    Text("یادداشت:")
                }
                
            } header: {
                
                Image(systemName: showEditView ? "checkmark" : "pencil")
                    .font(.title)
                    .padding()
                    .onTapGesture {
                        if showEditView {
//                            if let unwrappedBank = bank {
//                                vm.portfolioDataService.editBank(name: bankNameText, code: Double(bankCodeText) ?? 0, note: bankNoteText, entity: unwrappedBank)
//                            }
                            vm.portfolioDataService.editBank(name: bankNameText, code: Double(bankCodeText) ?? 0, note: bankNoteText, entity: bank!)
                            
                            
                            //                            vm.portfolioDataService.editToman(amount: Double(amountText) ?? 0, date: vm.dateAdded, note: noteText, entity: selectedTran!)
                            showEditView.toggle()
                        } else {
                            showEditView.toggle()
                        }
                        
                    }
            }
        }
        .modifier(PersianFourteenSolo())
        
    }
}

//struct BankEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        BankEditView()
//    }
//}
