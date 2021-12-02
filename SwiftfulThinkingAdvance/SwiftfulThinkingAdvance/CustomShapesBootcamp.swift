//
//  CustomShapesBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/2.
//

import SwiftUI


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset = rect.width * 0.2
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}

struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset = rect.width * 0.2
            path.move(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.minY))
        }
    }
}

struct CustomShapesBootcamp: View {
    var body: some View {
        ZStack {
//            Rectangle()
//                .trim(from: 0, to: 0.5)
//                .frame(width: 200, height: 200)
            
            // 三角形
//            Triangle()
//                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [10]))
//                .frame(width: 300, height: 300)
//                .foregroundColor(.pink)
            
//            Image("background")
//                .resizable()
//                .scaledToFill()
//                .frame(width: 300, height: 300)
//                .clipShape(
//                    Triangle()
//                        .rotation(Angle(degrees: 180))
//                )
            
            // 菱形
//            Diamond()
//                .frame(width: 300, height: 300)
            
            // 梯形
            Trapezoid()
                .frame(width: 300, height: 200)
            
            
        }
    }
}

struct CustomShapesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CustomShapesBootcamp()
    }
}
