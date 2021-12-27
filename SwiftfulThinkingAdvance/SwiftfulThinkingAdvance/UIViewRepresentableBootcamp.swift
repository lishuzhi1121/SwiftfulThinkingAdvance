//
//  UIViewRepresentableBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/11.
//

import SwiftUI

struct UIViewRepresentableBootcamp: View {
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            Text(text)
            HStack {
                Text("SwiftUI:")
                TextField("Type here...", text: $text)
                    .frame(height:55)
                    .background(.gray)
            }
            .padding(.horizontal)
            
            HStack {
                Text("UIKit:")
                UITextFieldRepresentable(text: $text)
                    .updatePlaceholder("Type here...")
                    .frame(height: 55)
                    .background(.gray)
            }
            .padding(.horizontal)
        }
        
    }
}

struct UIViewRepresentableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        UIViewRepresentableBootcamp()
    }
}


struct UITextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    let placeholderColor: UIColor
    
    init(text: Binding<String>, placeholder: String = "Default placeholder ...", placeholderColor: UIColor = .blue) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = getUITextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    // send data from SwiftUI to UIKit
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text;
    }
    
    // send data from UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    /// 获取自定义UITextField
    /// - Returns: UITextField对象
    private func getUITextField() -> UITextField {
        let textField = UITextField()
        let placeholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderColor
            ])
        textField.attributedPlaceholder = placeholder
        return textField
    }
    
    /// 更新placeholder
    /// - Parameter text: placeholder
    /// - Returns: UITextFieldRepresentable
    func updatePlaceholder(_ text: String) -> UITextFieldRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
    
}
