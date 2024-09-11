//
//  HomeScreen.swift
//  JustShorts
//
//  Created by 최준현 on 9/10/24.
//

import SwiftUI

struct HomeScreen: View {
    @State private var selection = "shorts"
    var body: some View {
        TabView(selection: $selection) {
            ShortsView()
                .tabItem {
                    Image(systemName: "arrowtriangle.right.fill")
                    Text("Shorts")
                }
            Text("")
                .tabItem {
                  Image(systemName: "plus")
                }
            Text("profile")
                .tabItem {
                    VStack{
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                }
        }
    }
}

#Preview {
    HomeScreen()
}
