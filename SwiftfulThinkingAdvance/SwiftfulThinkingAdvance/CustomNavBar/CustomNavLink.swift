//
//  CustomNavLink.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/9.
//

import SwiftUI

//struct NavigationLink<Label, Destination> : View where Label : View, Destination : View

//init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label)

struct CustomNavLink<Label: View, Destination: View>: View {
    
    let destination: Destination
    let label: Label
    
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            CustomNavBarContainerView {
                destination
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        } label: {
            label
        }

    }
}

struct CustomNavLink_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView {
            CustomNavLink {
                Text("Destination!")
            } label: {
                Text("ClickME!!")
            }
        }
    }
}
