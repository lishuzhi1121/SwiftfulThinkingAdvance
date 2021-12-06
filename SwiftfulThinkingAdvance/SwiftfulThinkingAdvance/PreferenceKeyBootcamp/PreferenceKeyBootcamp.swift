//
//  PreferenceKeyBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/6.
//

import SwiftUI

struct SecondaryScreen: View {
    @State var text: String = ""
    
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundColor(.pink)
        .onAppear(perform: getDataFromDatabase)
        .customTitle(text)
    }
    
    // 模拟异步获取数据
    func getDataFromDatabase() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async {
                self.text = "NEW TITLE FROM DATABASE!!!"
            }
        }
    }
}

struct CustomPreferenceKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
    
}

extension View {
    
    func customTitle(_ title: String) -> some View {
        preference(key: CustomPreferenceKey.self, value: title)
    }
    
}


struct PreferenceKeyBootcamp: View {
    
    @State private var title: String = "-"
    
    var body: some View {
        NavigationView {
            VStack {
//                Text("Hello, world!")
                SecondaryScreen(text: title)
                
            }
            .navigationTitle("Title is here!")
        }
        .onPreferenceChange(CustomPreferenceKey.self) { value in
            self.title = value
        }
    }
}

struct PreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceKeyBootcamp()
    }
}
