//
//  SplashScreen.swift
//  Awesome Chess
//
//  Created by Yunyi Wu on 18.03.2026..
//

import SwiftUI

struct SplashScreen: View {
    @State var isActive = false
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Image("chess_icon")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .cornerRadius(30)
                    .shadow(radius: 10)
                
                Text("Awesome Chess")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding(.top, 20)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
