//
//  ButtonStyleBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/11/29.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    let scaleAmount: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.8 : 1.0)
//            .brightness(configuration.isPressed ? 0.5 : 0)
            .scaleEffect(configuration.isPressed ? scaleAmount: 1.0)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle {
        PressableButtonStyle(scaleAmount: 0.9)
    }
}

extension View {
    func withPressableStyle(scaleAmout: CGFloat = 0.9) -> some View {
        buttonStyle(PressableButtonStyle(scaleAmount: scaleAmout))
    }
}


struct ButtonStyleBootcamp: View {
    @State var toggleTextColor: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Button Style Bootcamp!")
                .font(.headline)
                .foregroundColor(toggleTextColor ? .red : .black)
            
            Button {
                toggleTextColor.toggle()
            } label: {
                Text("Click Me!")
                    .font(.headline)
                    .withDefaultButtonFormatting()
                    
            }
            .withPressableStyle()

        }
        .padding(30)
    }
}

struct ButtonStyleBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ButtonStyleBootcamp()
    }
}
