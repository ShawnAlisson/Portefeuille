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
                
                //MARK: Main Screen and Configs
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                        .navigationTitle("")
                }
                .environmentObject(vm)
                .navigationViewStyle(StackNavigationViewStyle())
                
                //MARK: Set Lang and Dir Based on Setting
                .environment(\.locale, Locale.init(identifier: vm.translateState ? "en" : "fa"))
                .environment(\.layoutDirection, vm.translateState ? .leftToRight : .rightToLeft)
                
                
                //MARK: Launch Screen
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
                
                //MARK: Authentication on start
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
