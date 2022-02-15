//
//  AuthenticationManager.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 2/14/22.
//

import Foundation
import LocalAuthentication


class AuthenticationManager: ObservableObject {
  
    private(set) var context = LAContext()
    @Published private(set) var biometryType: LABiometryType = .none
    private(set) var canEvaluatePolicy = false
    @Published private(set) var isAuthenticated = false
    @Published private(set) var errorDescription: String?
    @Published var showAlert = false
    
    init() {
        getBiometryType()
    }
    
    func getBiometryType() {
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        biometryType = context.biometryType
    }
    
    func authenticateWithBiometric() async {
        context = LAContext()

        if canEvaluatePolicy {
            let reason = "تایید هویت برای ورود به والتم"

            do {
                let success = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)

                if success {
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        print("isAuthenticated", self.isAuthenticated)
                    }
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.errorDescription = error.localizedDescription
                    self.showAlert = true
                    self.biometryType = .none
                }
            }
        }
    }
}
