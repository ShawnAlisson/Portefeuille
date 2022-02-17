//
//  PrimaryButton.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 2/15/22.
//

import SwiftUI

struct PrimaryButton: View {
    
    var image: String?
    var showImage: Bool
    var text: String
    var disabled: Bool?
    
    var body: some View {
        HStack {
            Text(text)
                .font(Font.custom("BYekan+", size: 26))
                .foregroundColor(Color.theme.shadowColor)
                .padding(.horizontal, 5)
            
            if showImage {
                Image(systemName: image ?? "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.theme.shadowColor)
                    
            }
        }
        .opacity((disabled ?? false) ? 0.3 : 1)
        .padding()
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(30)
        .shadow(radius: 10)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(image: "faceid", showImage: true, text: "ورود", disabled: false)
    }
}
