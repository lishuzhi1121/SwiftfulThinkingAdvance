//
//  UIViewControllerRepresentableBootcamp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/12/28.
//

import SwiftUI

struct UIViewControllerRepresentableBootcamp: View {
    @State private var showScreen: Bool = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 300, height: 218)
            }
            
            Text("Hello, World!")

            
            Button {
                showScreen.toggle()
            } label: {
                Text("Click ME")
            }
            .sheet(isPresented: $showScreen) {
                
            } content: {
//                BasicUIViewControllerRepresentable(labelText: "New Here!")
//                    .ignoresSafeArea()
                UIImagePickerControllerRepresentable(image: $selectedImage, showScreen: $showScreen)
            }


        }
    }
}

struct UIViewControllerRepresentableBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        UIViewControllerRepresentableBootcamp()
    }
}

struct UIImagePickerControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var showScreen: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.allowsEditing = false
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> UIImagePickerCoordinator {
        return UIImagePickerCoordinator(image: $image, showScreen: $showScreen)
    }
    
    // Coordinator对象
    class UIImagePickerCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding var image: UIImage?
        @Binding var showScreen: Bool
        
        init(image: Binding<UIImage?>, showScreen: Binding<Bool>) {
            self._image = image
            self._showScreen = showScreen
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let newImage = info[.originalImage] as? UIImage else {
                return
            }
            
            image = newImage
            showScreen = false
        }
        
        // NOTE: 不实现这个协议方法默认点击取消会自动dismiss,
        // 实现了这个方法则不会自动dismiss
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            showScreen = false
//        }
        
        
    }
    
}



struct BasicUIViewControllerRepresentable: UIViewControllerRepresentable {
    let labelText: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = MyFirstViewController()
        vc.labelText = labelText
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

class MyFirstViewController: UIViewController {
    
    var labelText: String = "Hello"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let label = UILabel()
        label.text = labelText
        label.textColor = .white
        label.sizeToFit()
        label.center = view.center
        view.addSubview(label)
    }
    
    
}
