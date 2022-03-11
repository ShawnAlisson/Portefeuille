//
//  WalletamApp.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/4/22.
//
//  In The Name of Bug

import SwiftUI

@main
struct WalletamApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @StateObject private var authManager = AuthenticationManager()
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                //NavigationView for HomeView
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                        .navigationTitle("")
                }
                .environmentObject(vm)
                .navigationViewStyle(StackNavigationViewStyle())
                
                //Launch View on start
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
                
                //Authentication View on start
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
