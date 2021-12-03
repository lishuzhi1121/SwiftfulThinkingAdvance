//
//  CustomCurvesBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/2.
//

import SwiftUI

struct ArcSample: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: min(rect.width / 2, rect.height / 2),
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 30),
                clockwise: true)
        }
    }
}


struct ShapeWithArc: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            // top left
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            // top right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            // mid right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY - 70),
                radius: rect.width / 2,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 180),
                clockwise: false)
            
            // mid bottom
//            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
//            // mid left
//            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            // top left
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
    }
}

struct QuadCurve: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
//            path.move(to: .zero)
//            path.addQuadCurve(
//                to: CGPoint(x: rect.maxX, y: rect.maxY),
//                control: CGPoint(x: rect.minX, y: rect.maxY))
            
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.maxY),
                control: CGPoint(x: rect.midX, y: rect.minY - 100))
        }
    }
}


struct WaterShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.35))

            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.65))
            
            
//            path.addCurve(
//                to: CGPoint(x: rect.maxX, y: rect.midY),
//                control1: CGPoint(x: rect.midX, y: rect.height * 0.25),
//                control2: CGPoint(x: rect.midX, y: rect.height * 0.75))
            
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        }
    }
}

struct CustomCurvesBootcamp: View {
    var body: some View {
        WaterShape()
//            .stroke(lineWidth: 5)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.85), .black.opacity(0.9)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
            )
            .ignoresSafeArea()
//            .frame(width: 300, height: 300)
//            .rotationEffect(Angle(degrees: 90))
    }
}

struct CustomCurvesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CustomCurvesBootcamp()
    }
}
