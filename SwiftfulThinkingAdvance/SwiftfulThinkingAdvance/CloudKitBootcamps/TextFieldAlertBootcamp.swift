//
//  TextFieldAlertBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/16.
//

import SwiftUI

struct TextFieldAlertBootcamp: View {
    @State private var isPresent: Bool = false
    @State private var text: String = ""

    
    var body: some View {
        
        VStack {
            Text(text)
                .font(.headline)
            
            Button(action: {
                withAnimation(.spring()) {
                    self.isPresent.toggle()
                }
            }) {
                Text("Show alert")
            }
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
        
        
    }
}

struct TextFieldAlertBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldAlertBootcamp()
    }
}
