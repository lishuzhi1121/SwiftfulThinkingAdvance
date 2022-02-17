//
//  SwiftfulThinkingAdvanceApp.swift
//  SwiftfulThinkingAdvance
//
//  Created by SandsLee on 2021/11/29.
//

import SwiftUI

@main
struct SwiftfulThinkingAdvanceApp: App {
    
    let currentUserSignedIn: Bool
    
    init() {
//        self.currentUserSignedIn = CommandLine.arguments.contains("-UITest_startSignedIn")
//        self.currentUserSignedIn = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn")
        let value = ProcessInfo.processInfo.environment["-UITest_startSignedIn2"]
        self.currentUserSignedIn = value == "true"
        print("USER SIGNED IN: \(currentUserSignedIn)")
    }
    
    var body: some Scene {
        WindowGroup {
            CloudKitCRUDBootcamp()
//            UITestingBootcampView(currentUserIsSignedIn: currentUserSignedIn)
        }
    }
}
