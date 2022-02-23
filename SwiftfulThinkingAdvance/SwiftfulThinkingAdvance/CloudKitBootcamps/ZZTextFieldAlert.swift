//
//  ZZTextFieldAlert.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/2/16.
//

import SwiftUI

public struct ZZTextFieldAlertModel {
    // Title of the dialog
    public var title: String
    // Dialog message
    public var message: String? = nil
    // Text for the TextField
    public var text: String? = nil
    // Placeholder text for the TextField
    public var placeholder: String?
    // Keyboard tzpe of the TextField
    public var keyboardType: UIKeyboardType = .default
    // The left-most button label
    public var acceptTitle: String = "OK"
    public var acceptStyle: UIAlertAction.Style = .default
    // The optional cancel (right-most) button label
    public var cancelTitle: String? = "Cancel"
    public var cancelStyle: UIAlertAction.Style = .cancel
    // Triggers when either of the two buttons closes the dialog
    public var action: (_ text: String?) -> Void
}

extension UIAlertController {
    convenience init(alertModel: ZZTextFieldAlertModel) {
        self.init(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        // textfield
        self.addTextField {
            $0.text = alertModel.text
            $0.placeholder = alertModel.placeholder
            $0.keyboardType = alertModel.keyboardType
        }
        // cancel action
        if let cancelTitle = alertModel.cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: alertModel.cancelStyle) { action in
                alertModel.action(nil)
            }
            self.addAction(cancelAction)
        }
        // ok action
        let acceptAction = UIAlertAction(title: alertModel.acceptTitle, style: alertModel.acceptStyle) { action in
            let textField = self.textFields?.first
            alertModel.action(textField?.text)
        }
        self.addAction(acceptAction)
    }
}

struct ZZTextFieldAlertWrapper<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let alertModel: ZZTextFieldAlertModel
    let content: Content
    
    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        UIHostingController(rootView: content)
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.rootView = content
        // show
        if isPresented && uiViewController.presentedViewController == nil {
            // 修改action这个闭包主要是为了选择某个action之后将isPresented置为false
            var alert = self.alertModel
            alert.action = {
                self.isPresented = false
                self.alertModel.action($0)
            }
            context.coordinator.alertController = UIAlertController(alertModel: alert)
            uiViewController.present(context.coordinator.alertController!, animated: true)
        }
        // dismiss
        if !isPresented && uiViewController.presentedViewController != nil
            && uiViewController.presentedViewController == context.coordinator.alertController {
            uiViewController.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> ZZTextFieldAlertCoordinator {
        return ZZTextFieldAlertCoordinator()
    }
    
    final class ZZTextFieldAlertCoordinator {
        var alertController: UIAlertController?
        
        init(_ controller: UIAlertController? = nil) {
            self.alertController = controller
        }
    }
    
}

extension View {
    public func zzTextFieldAlert(isPresented: Binding<Bool>, alertModel: ZZTextFieldAlertModel) -> some View {
        ZZTextFieldAlertWrapper(isPresented: isPresented,
                                alertModel: alertModel,
                                content: self)
    }
}


//struct ZZTextFieldAlert: View {
//    @State private var text: String = "Hello, World!"
//    @State private var showAlert: Bool = false
//
//
//    var body: some View {
//        VStack {
//            Text(text)
//
//            Button {
//                showAlert.toggle()
//            } label: {
//                Text("Click")
//            }
//            .zzTextFieldAlert(isPresented: $showAlert, alertModel: ZZTextFieldAlertModel(title: "ZZTitle",
//                                                                                         message: "message",
//                                                                                         text: text,
//                                                                                         placeholder: "type something",
//                                                                                         keyboardType: .emailAddress,
//                                                                                         acceptTitle: "Update",
//                                                                                         acceptStyle: .default,
//                                                                                         cancelTitle: "Cancel",
//                                                                                         cancelStyle: .cancel) { text in
//                guard let text = text else { return }
//                print(text)
//                self.text = text
//            })
//        }
//
//    }
//}
//
//struct ZZTextFieldAlert_Previews: PreviewProvider {
//    static var previews: some View {
//        ZZTextFieldAlert()
//    }
//}
