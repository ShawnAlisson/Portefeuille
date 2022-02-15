//
//  WalletamApp.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/4/22.
//

import SwiftUI

@main
struct WalletamApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @StateObject private var authManager = AuthenticationManager()
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                //put Home View in Navigation View
                NavigationView {
                    
                    HomeView()
                        .navigationBarHidden(true)
                        .navigationTitle("")
                }
                .environmentObject(vm)
//                .environment(
//                  \.managedObjectContext,
//                   PortfolioDataService.instance.container.viewContext)
                .navigationViewStyle(StackNavigationViewStyle())
                
                //Launch View in start
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
                
                ZStack {
                    if !authManager.isAuthenticated && vm.authState {
                        LoginView()
                            .environmentObject(authManager)
                    }
                }
            }
            
        }
    }
}
