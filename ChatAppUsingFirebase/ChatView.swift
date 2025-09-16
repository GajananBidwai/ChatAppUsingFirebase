//
//  ChatView.swift
//  ChatAppUsingFirebase
//
//  Created by Neosoft on 15/09/25.
//

import SwiftUI

struct ChatView: View {
    
    var user: Users?
    
    var body: some View {
        Text("\(user?.name ?? "No User")")
    }
}

#Preview {
    ChatView()
}
