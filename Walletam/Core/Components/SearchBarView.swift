//
//  SearchBarView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/7/22.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchField: String
    var body: some View {
        HStack() {
            
            
            
            TextField("جستجو", text: $searchField)
                .multilineTextAlignment(.trailing)
                .font(Font.custom("BYekan+", size: 18))
                //.foregroundColor(Color.theme.accent)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: -20)
                        .foregroundColor(Color.theme.accent)
                        .disableAutocorrection(true)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchField = ""
                        }
                        .opacity(searchField.isEmpty ? 0.0 : 1.0)
                    , alignment: .leading
                )
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchField.isEmpty ?
                                 Color.theme.SecondaryText : Color.theme.accent)
            
        }
        .font(.headline)
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.theme.background))
        .shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 10, x: 0, y: 0)
    }
}

//MARK: PREVIEW
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchField: .constant(""))
                .previewLayout(.sizeThatFits)
            SearchBarView(searchField: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
}
