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
                .frame(width: 150, height: 150)
            
            VStack {
                Spacer()
                HStack(spacing: 25) {
                            Circle()
                        .fill(Color.theme.accent)
                                .frame(width: 16, height: 12)
                                .scaleEffect(animationAmount)
                                .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: animationAmount)
                            Circle()
                                .fill(Color.theme.accent)
                                .frame(width: 16, height: 12)
                                .scaleEffect(animationAmount)
                                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3), value: animationAmount)
                            Circle()
                                .fill(Color.theme.accent)
                                .frame(width: 16, height: 12)
                                .scaleEffect(animationAmount)
                                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6), value: animationAmount)
                        }
                        .padding(50)
                        .onAppear {
                            animationAmount = 2
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showLaunchView = false
                            }
                    }
            }
        }
    }
}

    
struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
