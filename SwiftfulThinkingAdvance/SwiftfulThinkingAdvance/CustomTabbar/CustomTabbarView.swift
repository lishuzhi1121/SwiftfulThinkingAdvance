//
//  CustomTabbarView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/6.
//

import SwiftUI

struct CustomTabbarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var tabsNamespace
    // 只让tabbar切换时有动画效果
    @State private var tabSelection: TabBarItem = .home
    
    var body: some View {
//        tabBarV1
        tabBarV2
            .onChange(of: selection) { newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.3)) {
                    tabSelection = newValue
                }
            }
    }
}

struct CustomTabbarView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .home, .favorites, .profile
    ]
    
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabbarView(tabs: tabs, selection: .constant(tabs.first!))
        }
        
    }
}

extension CustomTabbarView {
    
    private var tabBarV1: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView1(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(8)
        .background(.white)
    }
    
    private func tabView1(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(tab == tabSelection ? tab.color : .gray)
        .padding(.vertical, 8)
        .background(tab == tabSelection ? tab.color.opacity(0.3) : .white)
        .cornerRadius(10)
    }
    
    
    private func switchToTab(tab: TabBarItem) {
//        withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.5)) {
//        }
        selection = tab
    }
    
}

extension CustomTabbarView {
    
    private var tabBarV2: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView2(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(8)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private func tabView2(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
                .frame(maxWidth: .infinity)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(tab == tabSelection ? tab.color : .gray)
        .padding(.vertical, 8)
        .background(
            ZStack {
                if tab == tabSelection {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.3))
                        .matchedGeometryEffect(id: "tabs", in: tabsNamespace)
                }
            }
        )
    }
    
}



