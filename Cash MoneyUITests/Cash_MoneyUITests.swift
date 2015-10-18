//
//  Cash_MoneyUITests.swift
//  Cash MoneyUITests
//
//  Created by Yin Hua on 16/10/2015.
//  Copyright © 2015 Yin Hua. All rights reserved.
//

import XCTest

class Cash_MoneyUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAmountDisplayLabel(){
    
        let AUDTextFieldInput = "12345"
        
        let app = XCUIApplication()
    
        let inputTextField = app.textFields["AUDTextField"]
        inputTextField.tap()
        inputTextField.typeText(AUDTextFieldInput)
        
        
        let displayLabel = app.staticTexts["AmountDisplayLabel"]
        
        XCTAssertEqual(displayLabel.label, "12345", "just for testing")
        
        
    }
}
