//
//  MatchedGeometryEffectBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/1.
//

import SwiftUI

struct MatchedGeometryEffectBootcamp: View {
    @State var isClicked: Bool = false
    @Namespace var namespace
    var body: some View {
        VStack {
            if !isClicked {
                RoundedRectangle(cornerRadius: 5)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .frame(width: 100, height: 100)
                    .padding()
            }
            Spacer()
            if isClicked {
                RoundedRectangle(cornerRadius: 5)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .frame(width: 200, height: 200)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.pink)
        .onTapGesture {
            withAnimation {
                isClicked.toggle()
            }
        }
        
    }
}

struct MatchedGeometryEffectBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CategoryViewExample()
    }
}

struct CategoryViewExample: View {
    let categories = ["Home", "Popular", "Saved"]
    @State var selectedCategory = "Home"
    @Namespace var categoryNamespace
    
    var body: some View {
        HStack {
            ForEach(categories, id: \.self) { category in
                ZStack(alignment:.bottom) {
                    if category == selectedCategory {
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(.red.opacity(0.7))
//                            .matchedGeometryEffect(id: "category_back", in: categoryNamespace)
//                            .frame(width: 40, height: 2)
//                            .offset(y: 6)
                        
                        Image("home_indicator")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35)
                            .offset(y: 10)
                            .matchedGeometryEffect(id: "category_back", in: categoryNamespace)
                    }
                    
                    Text(category)
                        .font(.headline)
                        .foregroundColor(category == selectedCategory ? .red : .black)
                    
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.1)) {
                        selectedCategory = category
                    }
                }
                
            }
        }
        .padding()
    }
}
