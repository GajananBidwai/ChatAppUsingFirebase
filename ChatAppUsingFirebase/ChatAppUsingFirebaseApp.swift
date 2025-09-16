//
//  ChatAppUsingFirebaseApp.swift
//  ChatAppUsingFirebase
//
//  Created by Neosoft on 11/09/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ChatAppUsingFirebaseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if isLoggedIn{
                    ChatViewListView()
                }else {
                    ContentView()
                }
            }
        }
    }
}
