//
//  AnyTransitionBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/11/30.
//

import SwiftUI


struct RotateViewModifier: ViewModifier {
    let rotation: Double
    var rotateIn: Bool = true
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .offset(x: rotateIn ? (rotation == 0 ? 0 : UIScreen.main.bounds.width) : (rotation == 0 ? 0 : -UIScreen.main.bounds.width),
                    y: rotateIn ? (rotation == 0 ? 0 : UIScreen.main.bounds.height) : (rotation == 0 ? 0 : UIScreen.main.bounds.height))
    }
    
}

extension AnyTransition {
    
    static var rotating: AnyTransition {
        modifier(active: RotateViewModifier(rotation: 180), identity: RotateViewModifier(rotation: 0))
    }
    
    static func rotating(rotation: Double, isIn: Bool = true) -> AnyTransition {
        modifier(active: RotateViewModifier(rotation: rotation, rotateIn: isIn), identity: RotateViewModifier(rotation: 0, rotateIn: isIn))
    }
    
    static var rotateOn: AnyTransition {
        asymmetric(insertion: .rotating(rotation: 1080, isIn: true), removal: .rotating(rotation: 1080, isIn: false))
    }
}

struct AnyTransitionBootcamp: View {
    @State var showRectangle: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if showRectangle {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 150, height: 250)
                    .foregroundColor(.pink)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .transition(.move(edge: .leading))
//                    .modifier(RotateViewModifier(rotation: 45))
//                    .transition(.rotating.animation(.easeInOut))
                    .transition(.rotateOn)
            }
            
            
            Spacer()
            
            Text("Click Me!")
                .withDefaultButtonFormatting()
                .padding(.horizontal, 40)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.75)) {
                        showRectangle.toggle()
                    }
                }
        }
    }
}

struct AnyTransitionBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AnyTransitionBootcamp()
    }
}
