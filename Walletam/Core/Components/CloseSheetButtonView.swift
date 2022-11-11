//
//  CloseSheetButtonView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 3/12/22.
//

import SwiftUI

struct CloseSheetButtonView: View {
    
    @Binding var sheetToggle: Bool
    var disabled: Bool?
    
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Image(systemName: "chevron.compact.down")
                    .foregroundColor(Color.theme.SecondaryText.opacity(0.5))
                    .font(.largeTitle)
                    .padding(.top, 10)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .background(Color.theme.background.opacity(0.001))
                    .onTapGesture {
                        sheetToggle.toggle()
                    }
                    .opacity((disabled ?? false) ? 0 : 1)
                
                Spacer()
            }
            
            Spacer()
        }
    }
}

//struct CloseSheetButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CloseSheetButtonView()
//    }
//}
