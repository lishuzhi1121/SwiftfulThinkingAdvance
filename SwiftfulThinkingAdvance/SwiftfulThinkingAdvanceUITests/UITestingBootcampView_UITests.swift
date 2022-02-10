//
//  UITestingBootcampView_UITests.swift
//  SwiftfulThinkingAdvanceUITests
//
//  Created by SandsLee on 2022/2/7.
//

import XCTest
@testable import SwiftfulThinkingAdvance


// Name Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// Test Structure: Give, When, Then

class UITestingBootcampView_UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        app.launchArguments = ["-UITest_startSignedIn"]
        app.launchEnvironment = ["-UITest_startSignedIn2": "true"]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UITestingBootcampView_SignUpButton_shouldNotSignIn() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyBoard: false)
        
        // Then
        let navBar = app.navigationBars["Welcome"]
        XCTAssertFalse(navBar.exists)
    }
    
    func test_UITestingBootcampView_SignUpButton_shouldSignIn() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyBoard: true)
        
        // Then
        let navBar = app.navigationBars["Welcome"]
        XCTAssertTrue(navBar.exists)
                
    }
    
    func test_SignInHomeView_showAlertButton_shouldDispalayAlert() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyBoard: true)
        
        // When
        tapShowAlertButton(shouldDismiss: false)
        
        // Then
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists)
    }
    
    func test_SignInHomeView_showAlertButton_shouldDispalayAndDismissAlert() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyBoard: true)
        
        // When
        tapShowAlertButton(shouldDismiss: true)
        
        // Then
        let alert = app.alerts.firstMatch
        XCTAssertFalse(alert.exists)
    }
    
    
    func test_SignInHomeView_navigationLinkButton_shouldNavigateToDestination() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyBoard: true)
        
        // When
        tapNavigationLinkButton(shouldBack: false)
        
        // Then
        let destination = app.staticTexts["Destination"]
        XCTAssertTrue(destination.exists)
    }
    
    func test_SignInHomeView_navigationLinkButton_shouldNavigateToDestinationAndBack() {
        // Given
        signUpAndSignIn(shouldTypeOnKeyBoard: true)
        
        // When
        tapNavigationLinkButton(shouldBack: true)
        
        // Then
        let navBar = app.navigationBars["Welcome"]
        XCTAssertTrue(navBar.exists)
    }
    

}

extension UITestingBootcampView_UITests {
    
    /// 注册登录
    /// - Parameter shouldTypeOnKeyBoard: 是否输入用户名
    func signUpAndSignIn(shouldTypeOnKeyBoard: Bool) {
        let startSignedIn = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn")
        guard !startSignedIn else { return }
        
        let textField = app.textFields["UserNameTextField"]
        textField.tap()
        if shouldTypeOnKeyBoard {
            typeInUserNameFromKeyBoard()
        }
        let returnKey = app.buttons["Return"]
        returnKey.tap()
        
        let signUpKey = app.buttons["SignUpButton"]
        signUpKey.tap()
    }
    
    /// 从键盘输入用户名
    func typeInUserNameFromKeyBoard() {
        let sKey = app.keys["S"]
        sKey.tap()
        let aKey = app.keys["a"]
        aKey.tap()
        let nKey = app.keys["n"]
        nKey.tap()
        let dKey = app.keys["d"]
        dKey.tap()
        let sKey2 = app.keys["s"]
        sKey2.tap()
    }
    
    /// 点击显示弹窗按钮
    /// - Parameter shouldDismiss: 是否需要关闭
    func tapShowAlertButton(shouldDismiss: Bool) {
        let showAlertButton = app.buttons["ShowAlertButton"]
        showAlertButton.tap()
        if shouldDismiss {
            let alert = app.alerts.firstMatch
            let alertOKButton = alert.buttons["OK"]
            alertOKButton.tap()
        }
    }
    
    /// 点击导航按钮
    /// - Parameter shouldBack: 是否需要返回
    func tapNavigationLinkButton(shouldBack: Bool) {
        let navigationLinkButton = app.buttons["NavigationLink"]
        navigationLinkButton.tap()
        if shouldBack {
            let backButton = app.navigationBars.buttons["Welcome"]
            backButton.tap()
        }
    }
    
}
