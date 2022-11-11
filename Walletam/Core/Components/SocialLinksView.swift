//
//  SocialLinksView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/27/22.
//

import SwiftUI

struct SocialLinksView: View {
    
    let websiteURL: String?
    let githubURL: String?
    let redditURL: String?
    let telegramURL: String?
    let twitterURL: String?
    
    var body: some View {
        HStack(spacing: 25) {
            if let websiteString = websiteURL,
               let url = URL(string: websiteString) {
                Link(destination: url) {
                    Image(systemName: "globe.asia.australia.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.theme.bwColor)
                        .frame(width: 30, height: 30)
                }
            }
            if let githubString = githubURL,
               let url = URL(string: githubString) {
                Link(destination: url) {
                    Image("github-fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.theme.bwColor)
                        .frame(width: 31, height: 31)
                }
            }
            
            if let redditString = redditURL,
               let url = URL(string: redditString) {
                Link(destination: url) {
                    Image("reddit-fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.theme.bwColor)
                        .frame(width: 31, height: 31)
                }
            }
            
            if let telegramString = telegramURL,
               let url = URL(string: "https://t.me/\(telegramString)") {
                Link(destination: url) {
                    Image("telegram-circle-fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.theme.bwColor)
                        .frame(width: 31, height: 31)
                }
                
                
                if let twitterString = twitterURL,
                   let url = URL(string: twitterString) {
                    Link(destination: url) {
                        Image("twitter-circle-fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.theme.bwColor)
                            .frame(width: 31, height: 31)
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: Color.theme.shadowColor.opacity(0.2), radius: 10, x: 0, y: 0)
        .padding()
    }
}

//struct SocialLinksView_Previews: PreviewProvider {
//    static var previews: some View {
//        SocialLinksView()
//    }
//}
