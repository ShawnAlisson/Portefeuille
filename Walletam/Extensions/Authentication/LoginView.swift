//
//  LoginView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 2/14/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        VStack{
            HStack{
                switch authManager.biometryType {
                case .faceID:
                    PrimaryButton(image: "faceid", showImage: true, text: "ورود با تشخیص چهره")
                        .onTapGesture {
                            Task.init {
                                await
                                authManager.authenticateWithBiometric()
                            }
                        }
                case .touchID:
                    PrimaryButton(image: "touchid", showImage: true, text: "ورود با اثر انگشت")
                        .onTapGesture {
                            Task.init {
                                await
                                authManager.authenticateWithBiometric()
                            }
                        }
                default:
                   PrimaryButton(image: "person.fill", showImage: true, text: "ورود")
                        .onTapGesture {
                            Task.init {
                                await
                                authManager.authenticateWithBiometric()
                            }
                        }
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                Task.init {
                    await
                    authManager.authenticateWithBiometric()
                }
            }
//            .alert(isPresented:
//                    $authManager.showAlert) {
//                Alert(title: Text("ERROR"), message: Text(authManager.errorDescription ?? "ERROR"))
//            }
            
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationManager())
    }
}
