//
//  SplashScreenView.swift
//  Notes
//
//  Created by Pavel on 1.02.23.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            HomeView()
        } else {
            VStack {
                VStack {
                    Image("Splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 190, height: 190, alignment: .center)
                    Text("Notes")
                        .font(Font.custom("MarkPro-Bold", size: 36))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
