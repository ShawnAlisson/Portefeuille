//
//  SwiftUIView.swift
//  Walletam
//
//  Created by Shayan Alizadeh on 1/29/22.
//

import SwiftUI

struct SwiftUIView: View {
    
    
    var body: some View {
        
        
        
        ScrollView(.horizontal) {
                    LazyHStack {
                        VStack {
                            
                                ForEach(0...50, id: \.self) { index in
                                    
                                    Text(String(index))
                                        .onAppear {
                                            print(index)
                                        }
                            
                            }
                            
                        
                        }
                    }
                }
        
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
