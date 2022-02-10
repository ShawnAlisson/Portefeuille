//
//  CircleButtonView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/5/22.
//

import SwiftUI

struct RecButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.title)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(Rectangle()
                            .cornerRadius(10)
                            .foregroundColor(Color.theme.background)
            )
            .shadow(
                color: Color.theme.shadowColor.opacity(0.25),
                radius: 10, x: 0, y: 0)
            .padding()
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecButtonView(iconName: "info")
                .previewLayout(.sizeThatFits)
            RecButtonView(iconName: "plus")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
        }
        
    }
}
