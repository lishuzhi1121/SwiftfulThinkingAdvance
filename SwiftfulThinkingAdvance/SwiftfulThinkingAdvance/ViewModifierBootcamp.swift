//
//  ViewModifierBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/11/29.
//

import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(8)
            .shadow(radius: 5)
    }
}

extension View {
    func withDefaultButtonFormatting(backgroundColor: Color = .blue) -> some View {
        modifier(DefaultButtonViewModifier(backgroundColor: backgroundColor))
    }
}

struct ViewModifierBootcamp: View {
    var body: some View {
        VStack(spacing: 15) {
            Text("Hello, World!")
                .font(.title)
                .withDefaultButtonFormatting(backgroundColor: .orange)
//                .modifier(DefaultButtonViewModifier())
//                .font(.headline)
//                .foregroundColor(.white)
//                .frame(height: 55)
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .cornerRadius(10)
//                .shadow(radius: 10)
//                .padding()
            
            Text("Hello, Everyone!")
                .font(.headline)
                .withDefaultButtonFormatting()
            
            Text("Hello, Me!")
                .font(.callout)
                .withDefaultButtonFormatting(backgroundColor: .pink)
        }
        .padding()
    }
}

struct ViewModifierBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ViewModifierBootcamp()
    }
}
