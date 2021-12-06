//
//  ScrollViewOffsetPreferenceKeyBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/6.
//

import SwiftUI


struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}

extension View {
    
    func onScrollViewOffsetChanged(_ changed: @escaping (_ offset: CGFloat) -> Void) -> some View {
        self
            .background(
                GeometryReader { geo in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                //            scrollViewOffset = value
                changed(value)
            }
    }
    
}


struct ScrollViewOffsetPreferenceKeyBootcamp: View {
    let title: String = "NEW TITLE!!!"
    @State var scrollViewOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack {
                titleLayer
                    .opacity(scrollViewOffset / 63.0)
                    .onScrollViewOffsetChanged { offset in
                        scrollViewOffset = offset
                    }
                
                contentLayer
            }
            .padding()
        }
        .overlay {
            Text("\(scrollViewOffset)")
        }
        .overlay(alignment: .top) {
            navLayer
                .opacity(scrollViewOffset < 0 ? 1.0 : (scrollViewOffset < 20 ? (1.0 - (scrollViewOffset / 20)) : 0))
        }
    }
}

struct ScrollViewOffsetPreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewOffsetPreferenceKeyBootcamp()
    }
}


extension ScrollViewOffsetPreferenceKeyBootcamp {
    var titleLayer: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var navLayer: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(.blue)
    }
    
    var contentLayer: some View {
        ForEach(0..<30) { _ in
            RoundedRectangle(cornerRadius: 10)
                .fill(.pink.opacity(0.3))
                .frame(width: 300, height: 200)
        }
    }
    
}
