//
//  TabBarItem.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/6.
//

import Foundation
import SwiftUI

//var tabs: [TabBarItem] = [
//    TabBarItem(iconName: "house", title: "Home", color: .pink),
//    TabBarItem(iconName: "heart", title: "Favorites", color: .orange),
//    TabBarItem(iconName: "person", title: "Profile", color: .green)
//]
//
//struct TabBarItem: Hashable {
//    let iconName: String
//    let title: String
//    let color: Color
//}

// NOTE: 枚举要遵守Hashable协议，否则无法比较会导致点击切换tab没有反应
enum TabBarItem: Hashable {
    case home, favorites, message, profile

    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .favorites:
            return "heart"
        case .message:
            return "message"
        case .profile:
            return "person"
        }
    }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .favorites:
            return "Favorites"
        case .message:
            return "Message"
        case .profile:
            return "Profile"
        }
    }

    var color: Color {
        switch self {
        case .home:
            return Color.pink
        case .favorites:
            return Color.blue
        case .message:
            return Color.orange
        case .profile:
            return Color.yellow
        }
    }

}
