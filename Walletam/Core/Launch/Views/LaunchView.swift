//
//  LaunchView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/15/22.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var animationAmount = 1.0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            Image("roundedLogo")
                .resizable()
                .frame(width: 85, height: 85)
            
            LoadingDotsAnimationView(animationAmount: animationAmount, showLaunchView: $showLaunchView)
        }
    }
}

//MARK: PREVIEW
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
