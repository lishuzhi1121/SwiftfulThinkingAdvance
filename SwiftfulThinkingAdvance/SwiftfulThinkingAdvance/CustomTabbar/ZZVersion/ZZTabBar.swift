//
//  ZZTabBar.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/7.
//

import SwiftUI

struct ZZTabBar: View {
    @Binding var selection: ZZTabBarItem
    let tabs: [ZZTabBarItem]
    @State private var localSelection: ZZTabBarItem = .home
    @Namespace private var tabbarItemNamespace
    
    
    var body: some View {
        tabbarView
            .onChange(of: selection) { newValue in
                withAnimation(.easeInOut) {
                    localSelection = selection
                }
            }
    }
}

struct ZZTabBar_Previews: PreviewProvider {
    
    static let tabs: [ZZTabBarItem] = [
        .home, .favorites, .profile
    ]
    
    static var previews: some View {
        ZZTabBar(selection: .constant(.home), tabs: tabs)
    }
}

extension ZZTabBar {
    
    var tabbarView: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabbarItemView(tab: tab)
                    .onTapGesture {
                        selection = tab
                    }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private func tabbarItemView(tab: ZZTabBarItem) -> some View {
        VStack {
            Image(systemName:tab.iconName)
                .font(.subheadline)
                .frame(maxWidth: .infinity)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .foregroundColor(tab == localSelection ? tab.color : .gray)
        .background(
            ZStack {
                if tab == localSelection {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.4))
                        .matchedGeometryEffect(id: "zztabbar_item", in: tabbarItemNamespace)
                }
            }
        )
    }
    
}
