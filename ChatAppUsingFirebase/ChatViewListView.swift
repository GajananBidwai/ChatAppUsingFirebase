//
//  ChatViewListView.swift
//  ChatAppUsingFirebase
//
//  Created by Neosoft on 12/09/25.
//

import SwiftUI

struct ChatViewListView: View {
    
    var users = [Users(id: 1, name: "Virat"),
                 Users(id: 2, name: "Rohit"),
                 Users(id: 3, name: "Sachin")]
    
    var body: some View {
        NavigationStack{
            List(users){ result in
                
                NavigationLink {
                    ChatView(user: result)
                } label: {
                    Text("\(result.name)")
                }

                
            }
        }
        
    }
}

#Preview {
    ChatViewListView()
}
