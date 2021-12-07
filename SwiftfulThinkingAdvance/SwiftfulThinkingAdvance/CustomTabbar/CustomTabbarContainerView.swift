//
//  CustomTabbarContainerView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/6.
//

import SwiftUI

struct CustomTabbarContainerView<Content: View>: View {
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .ignoresSafeArea()
            
            CustomTabbarView(tabs: tabs, selection: $selection)
        }
        .onPreferenceChange(TabbarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

struct CustomTabbarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabbarContainerView(selection: .constant(.home)) {
            Color.pink
        }
    }
}
