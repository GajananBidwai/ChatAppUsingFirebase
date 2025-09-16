//
//  ToastMassage.swift
//  ChatAppUsingFirebase
//
//  Created by Neosoft on 15/09/25.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var message: String
    @Binding var show: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if show {
                VStack {
                    Spacer()
                    Text(message)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: show)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            show = false
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func toast(message: Binding<String>, show: Binding<Bool>) -> some View {
        self.modifier(ToastModifier(message: message, show: show))
    }
}


