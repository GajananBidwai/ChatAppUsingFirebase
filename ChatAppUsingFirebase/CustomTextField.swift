//
//  CustomTextField.swift
//  ChatAppUsingFirebase
//
//  Created by Neosoft on 15/09/25.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    let placerHolder: String
    @Binding var value: String
    var errorMessage: String? = nil   // optional error from parent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Label(title, systemImage: "person.circle")
                .bold()
                .font(.system(size: 20))
                .padding(.top, 5)
            
            TextField(placerHolder, text: $value)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    }
}
