//
//  TextFieldAlertBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/16.
//

import SwiftUI

struct TextFieldAlertBootcamp: View {
    @State private var isPresent: Bool = false
    @State private var text: String = "----"
    let items = ["abc", "def", "ghi", "123", "456", "789"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text(text)
                    .font(.headline)
                List {
                    ForEach(items, id: \.self) {
                        Text($0)
                            .onTapGesture {
                                self.isPresent.toggle()
                            }
                    }
                }
                .listStyle(.plain)
                .zzTextFieldAlert(isPresented: $isPresent,
                                  alertModel: ZZTextFieldAlertModel(title: "ZZTitle",
                                                                    message: "message",
                                                                    text: nil,
                                                                    placeholder: "type here...",
                                                                    keyboardType: .default,
                                                                    acceptTitle: "OK",
                                                                    acceptStyle: .default,
                                                                    cancelTitle: "Cancel",
                                                                    cancelStyle: .cancel,
                                                                    action: { text in
                    guard let text = text else { return }
                    print(text)
                    self.text = text
                }))
            }
            .navigationBarHidden(true)
        }
        
        
        
    }
}

struct TextFieldAlertBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldAlertBootcamp()
    }
}
