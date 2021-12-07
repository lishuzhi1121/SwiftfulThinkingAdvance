//
//  ZZTabBarItemsPreferenceKey.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/7.
//

import Foundation
import SwiftUI

struct ZZTabBarItemsPreferenceKey: PreferenceKey {
    
    static var defaultValue: [ZZTabBarItem] = []
    
    static func reduce(value: inout [ZZTabBarItem], nextValue: () -> [ZZTabBarItem]) {
        value += nextValue()
    }
    
}


struct ZZTabBarItemsModifier: ViewModifier {
    
    let item: ZZTabBarItem
    @Binding var selection: ZZTabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(item == selection ? 1 : 0)
            .preference(key: ZZTabBarItemsPreferenceKey.self, value: [item])
    }
    
}

extension View {
    
    func zztabItem(item: ZZTabBarItem, selection: Binding<ZZTabBarItem>) -> some View {
        modifier(ZZTabBarItemsModifier(item: item, selection: selection))
    }
    
}
