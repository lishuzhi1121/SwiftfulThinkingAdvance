//
//  ZZTabView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/7.
//

import SwiftUI

struct ZZTabView<Content: View>: View {
    
    @Binding var selection: ZZTabBarItem
    let content: Content
    // 通过PreferenceKey更新
    @State private var tabs: [ZZTabBarItem] = []
    
    init(selection: Binding<ZZTabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            ZZTabBar(selection: $selection, tabs: tabs)
        }
        .onPreferenceChange(ZZTabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct ZZTabView_Previews: PreviewProvider {
    static let tabs: [ZZTabBarItem] = [
        .home, .favorites, .profile
    ]
    
    static var previews: some View {
        ZZTabView(selection: .constant(.home)) {
            Color.blue
        }
    }
}
