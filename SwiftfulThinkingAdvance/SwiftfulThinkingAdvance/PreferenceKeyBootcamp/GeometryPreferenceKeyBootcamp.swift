//
//  GeometryPreferenceKeyBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/6.
//

import SwiftUI


struct RectangleGeometrySizePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
    
}

extension View {
    func updateRectangleGeoSize(_ size: CGSize) -> some View {
        preference(key: RectangleGeometrySizePreferenceKey.self, value: size)
    }
}

struct GeometryPreferenceKeyBootcamp: View {
    
    @State var rectSize: CGSize = .zero
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Hello, world!")
                .frame(width: rectSize.width, height: rectSize.height)
                .font(.headline)
                .background(.pink)
            
            Spacer()
            
            HStack  {
                Rectangle()
                
                GeometryReader { geo in
                    Rectangle()
                        .updateRectangleGeoSize(geo.size)
                        .overlay(
                            Text("\(geo.size.width)")
                                .foregroundColor(.white)
                        )
                }
                
                Rectangle()
            }
            .frame(height: 55)
//            .padding()
            
            Spacer()
        }
        .onPreferenceChange(RectangleGeometrySizePreferenceKey.self) { value in
            self.rectSize = value
        }
    }
}

struct GeometryPreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GeometryPreferenceKeyBootcamp()
    }
}
