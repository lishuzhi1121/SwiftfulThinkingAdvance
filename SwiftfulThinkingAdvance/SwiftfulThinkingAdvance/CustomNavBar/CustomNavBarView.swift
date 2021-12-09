//
//  CustomNavBarView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/9.
//

import SwiftUI


extension CustomNavBarView {
    
    private var navBackButton: some View {
        Button {
            // action here
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
        }
    }
    
    private var navTitleSection: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            if let subtitle = subtitle {
                Text(subtitle)
            }
        }
    }
    
}


struct CustomNavBarView: View {
    @Environment(\.presentationMode) var presentationMode
    let showBackButton: Bool
    let title: String
    let subtitle: String?
    
    var body: some View {
        HStack {
            if showBackButton {
                navBackButton
            }
            
            Spacer()
            
            navTitleSection
            
            Spacer()
            
            if showBackButton {
                // 等距离占位用
                navBackButton
                    .opacity(0)
            }
        }
        .accentColor(.white)
        .foregroundColor(.white)
        .font(.headline)
        .padding()
        .background(.blue)
    }
}

struct CustomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavBarView(showBackButton: true, title: "Title Here", subtitle: "Subtitle goes here...")
            Spacer()
        }
    }
}
