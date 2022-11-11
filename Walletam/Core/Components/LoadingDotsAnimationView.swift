//
//  LoadingDotsAnimationView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 2/19/22.
//

import SwiftUI

struct LoadingDotsAnimationView: View {
    
    @State var animationAmount: Double
    
    @Binding var showLaunchView: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 25) {
                        Circle()
                    .fill(Color.theme.accent)
                            .frame(width: 12, height: 8)
                            .scaleEffect(animationAmount)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: animationAmount)
                        Circle()
                            .fill(Color.theme.accent)
                            .frame(width: 12, height: 8)
                            .scaleEffect(animationAmount)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3), value: animationAmount)
                        Circle()
                            .fill(Color.theme.accent)
                            .frame(width: 12, height: 8)
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

//MARK: PREVIEW
struct LoadingDotsAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingDotsAnimationView(animationAmount: 1.0, showLaunchView: .constant(true))
    }
}
