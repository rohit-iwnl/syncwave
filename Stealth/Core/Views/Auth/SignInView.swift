//
//  SignInView.swift
//  StealthKekw10$

//  Created by Rohit Manivel on 8/30/24.
//

import SwiftUI

struct SignInView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        ZStack{
            Color(TextColors.primaryBlack.color)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Spacer()
                    Image("Logo/white")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                    Spacer()
                }
                .padding(.vertical)

                
                SignInSheet(
                    appUser: .constant(nil)
                )
            }
            .padding(.horizontal)
            .foregroundStyle(TextColors.primaryWhite.color)
        }
        
    }
}


struct AnimatedMeshGradient: View {
    @State private var start = UnitPoint(x: 0, y: 0)
    @State private var end = UnitPoint(x: 1, y: 1)
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Color.blue, Color.purple, Color.pink]
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(.easeInOut(duration: 6).repeatForever(), value: start)
            .animation(.easeInOut(duration: 6).repeatForever(), value: end)
            .onReceive(timer) { _ in
                self.start = UnitPoint(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1))
                self.end = UnitPoint(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1))
            }
            .mask(
                Image("Logo/white")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            )
    }
}


#Preview {
    SignInView()
        
}
