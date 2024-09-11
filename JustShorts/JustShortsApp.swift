//
//  JustShortsApp.swift
//  JustShorts
//
//  Created by 최준현 on 9/6/24.
//

import SwiftUI

@main
struct JustShortsApp: App {
    @State private var authStore = AuthStore()
    var body: some Scene {
        WindowGroup {
            if authStore.loginState == .login{
                HomeScreen()
            }else{
                LoginScreen(authStore: authStore)
            }
            
        }
    }
}
