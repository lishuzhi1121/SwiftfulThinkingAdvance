//
//  CustomNavBarContainerView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/9.
//

import SwiftUI

struct CustomNavBarContainerView<Content>: View where Content : View {
    let content: Content
    @State private var showBackButton: Bool = true
    @State private var title: String = ""
    @State private var subtitle: String? = nil
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavBarView(showBackButton: showBackButton, title: title, subtitle: subtitle)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(CustomNavBarTitlePrefrenceKey.self) { value in
            self.title = value
        }
        .onPreferenceChange(CustomNavBarSubtitlePrefrenceKey.self) { value in
            self.subtitle = value
        }
        .onPreferenceChange(CustomNavBarBackButtonHiddenPrefrenceKey.self) { value in
            self.showBackButton = !value
        }
        
    }
}

struct CustomNavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBarContainerView {
            ZStack {
                Color.green.ignoresSafeArea()
                
                Text("Hello, world!")
                    .foregroundColor(.white)
            }
            .customNavigationTitle("Preview Title")
            .customNavigationSubtitle("preview subtitle here...")
            .customNavigationBarBackButtonHidden(true)
        }
    }
}
