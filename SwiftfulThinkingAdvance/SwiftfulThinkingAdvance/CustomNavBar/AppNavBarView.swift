//
//  AppNavBarView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/9.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
//        defaultNavView
        
        CustomNavView {
            ZStack {
                Color.yellow.ignoresSafeArea()
                
                CustomNavLink {
                    Text("Destionation!!!")
                        .customNavigationTitle("Secondary Title")
//                        .customNavigationSubtitle("")
//                        .customNavigationBarBackButtonHidden(false)
                } label: {
                    Text("Navigate")
                        .font(.title)
                        .foregroundColor(.blue)
                }

            }
            .customNavigationTitle("Custom Title")
            .customNavigationSubtitle("custom subtitle goes...")
            .customNavigationBarBackButtonHidden(true)
        }
    }
}

struct AppNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavBarView()
    }
}


extension AppNavBarView {
    private var defaultNavView: some View {
        NavigationView {
            ZStack {
                Color.green
                
                NavigationLink {
                    Text("Hello, world!")
                        .navigationTitle(Text("Secondary!"))
                        .navigationBarBackButtonHidden(false)
                } label: {
                    Text("NavigationLink")
                }

            }
            .ignoresSafeArea()
            .navigationTitle(Text("Nav Title Here"))
        }
    }
}
