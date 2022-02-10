//
//  UITestingBootcampView.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2022/1/26.
//

import SwiftUI

class UITestingBoocampViewModel: ObservableObject {
    let placeholder = "Type your name here..."
    @Published var textFieldText = ""
    @Published var currentUserIsSignedIn: Bool
    
    init(currentUserIsSignedIn: Bool) {
        self.currentUserIsSignedIn = currentUserIsSignedIn
    }
    
    func signUpButtonClick() {
        guard !textFieldText.isEmpty else { return }
        currentUserIsSignedIn = true
    }
    
}

struct UITestingBootcampView: View {
    @StateObject private var vm: UITestingBoocampViewModel
    
    init(currentUserIsSignedIn: Bool) {
        _vm = StateObject(wrappedValue: UITestingBoocampViewModel(currentUserIsSignedIn: currentUserIsSignedIn))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ZStack {
                if !vm.currentUserIsSignedIn {
                    signUpLayer
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
                
                if vm.currentUserIsSignedIn {
                    SignedInHomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                }
            }
            
        }
    }
}


extension UITestingBootcampView {
    
    private var signUpLayer: some View {
        VStack {
            TextField(vm.placeholder, text: $vm.textFieldText)
                .accessibilityIdentifier("UserNameTextField") // for UITests
                .font(.headline)
                .padding()
                .background(.white)
                .cornerRadius(10)
            
            Button {
                withAnimation(.spring()) {
                    vm.signUpButtonClick()
                }
            } label: {
                Text("Sign Up")
                    .accessibilityIdentifier("SignUpButton") // for UITests
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
}


struct UITestingBootcampView_Previews: PreviewProvider {
    static var previews: some View {
        UITestingBootcampView(currentUserIsSignedIn: true)
    }
}


struct SignedInHomeView: View {
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show Alert")
                        .accessibilityIdentifier("ShowAlertButton")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.red)
                        .cornerRadius(10)
                }
                .alert("Welcome", isPresented: $showAlert) {
                    // 添加.destructive的action button时, 会自动带有.cancel的action button
//                    Button(role: .destructive) {
//
//                    } label: {
//                        Text("Delete")
//                    }
                    
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Cancel")
                    }

                    
                    Button {
                        
                    } label: {
                        Text("OK")
                    }



                } message: {
                    Text("Welcom to the app!")
                }

                
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .accessibilityIdentifier("NavigationLink")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}
