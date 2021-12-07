//
//  AppTabbarView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/6.
//

import SwiftUI

struct AppTabbarView: View {
    @State private var selection: String = "Home"
    @State private var customSelection: TabBarItem = .home
    
    @State private var tabSelection: ZZTabBarItem = .home
    
    var body: some View {
        //defaultTabbarView
        
        ZZTabView(selection: $tabSelection) {
            Color.pink
                .zztabItem(item: .home, selection: $tabSelection)
            
            Color.green
                .zztabItem(item: .favorites, selection: $tabSelection)
            
            Color.blue
                .zztabItem(item: .profile, selection: $tabSelection)
        }
        
        
//        CustomTabbarContainerView(selection: $customSelection) {
//            Color.yellow
//                .tabbarItem(tab: .home, selection: $customSelection)
//
//            Color.green
//                .tabbarItem(tab: .favorites, selection: $customSelection)
//
//            Color.orange
//                .tabbarItem(tab: .message, selection: $customSelection)
//
//            Color.blue
//                .tabbarItem(tab: .profile, selection: $customSelection)
//
//        }
    }
}

struct AppTabbarView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppTabbarView()
    }
}

extension AppTabbarView {
    var defaultTabbarView: some View {
        TabView(selection: $selection) {
            Color.pink
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
            
            Color.orange
                .tabItem {
                    VStack {
                        Image(systemName: "heart")
                        Text("Favorite")
                    }
                }
            
            Color.blue
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }
        }
    }
}
