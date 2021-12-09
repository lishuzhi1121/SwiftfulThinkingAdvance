//
//  CustomNavView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/9.
//

import SwiftUI

struct CustomNavView<Content>: View where Content : View {
    
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        NavigationView {
            CustomNavBarContainerView(content: content)
                .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

struct CustomNavView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView {
            ZStack {
                Color.green.ignoresSafeArea()
                
                NavigationLink {
                    Text("Destionation!!!")
                } label: {
                    Text("Navigate")
                        .foregroundColor(.blue)
                }
                
            }
        }
    }
}


// handle PopGesture
extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
    
}
