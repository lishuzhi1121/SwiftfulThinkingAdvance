//
//  TabbarItemsPreferenceKey.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/6.
//

import Foundation
import SwiftUI

struct TabbarItemsPreferenceKey: PreferenceKey {
    
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
    
}

struct TabbarItemsModifier: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0)
            .preference(key: TabbarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    
    func tabbarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        modifier(TabbarItemsModifier(tab: tab, selection: selection))
    }
    
}
