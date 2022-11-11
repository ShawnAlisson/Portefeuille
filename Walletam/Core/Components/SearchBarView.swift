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
            
            
            
            TextField("search", text: $searchField)
                .multilineTextAlignment(.leading)
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
                    , alignment: .trailing
                )
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchField.isEmpty ?
                                 Color.theme.SecondaryText : Color.theme.accent)
            
        }
        .font(.headline)
        .padding()
        .background(
        RoundedRectangle(cornerRadius: 30)
            .fill(Color.theme.secondaryBg))
        .shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 0 , x: 2, y: 2)
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
