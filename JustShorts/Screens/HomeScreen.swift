//
//  HomeScreen.swift
//  JustShorts
//
//  Created by 최준현 on 9/10/24.
//

import SwiftUI

struct HomeScreen: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            
            Tab("Shorts", systemImage: "arrowtriangle.right.fill", value: 0) {
                ShortsView()
            }
            
            Tab(value: 1){
                CameraView()
            } label: {
                Image(systemName: "plus")
            }
            
            Tab(value: 2){
                Text("profile")
            }label: {
                VStack{
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
            }
        }
        .onAppear{
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(Color.orange.opacity(0.2))
            
            // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().standardAppearance = appearance
            // Use this appearance when scrolled all the way up:
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    HomeScreen()
}
