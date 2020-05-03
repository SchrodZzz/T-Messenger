//
//  T_MessengerUITests.swift
//  T MessengerUITests
//
//  Created by Suspect on 03.05.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import XCTest

@testable import T_Messenger

class TMessengerUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
    }

    func testExample() {
        // Given
        let testWord = "TestWord123!@# "
        
        // When
        let app = XCUIApplication()
        app.launch()
        
        app.navigationBars.buttons["Profile"].tap()
        app.buttons["Edit"].tap()
        app.textViews.firstMatch.tap()
        
        app.textViews.firstMatch.typeText(testWord)
        
        app.buttons["Edit"].tap()
        
        let alert = app.alerts.firstMatch
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: alert, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        let screenshot = alert.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "ProfileSaveResult"
        attachment.lifetime = .keepAlways
        add(attachment)
        
        app.alerts.firstMatch.buttons.firstMatch.tap()
        
        app.swipeDown()
        app.navigationBars.buttons["Profile"].tap()
        
        // Then
        let profileTextViewValue = app.textViews.firstMatch.value as? String
        let profileTextViewValuePrefix = profileTextViewValue?.prefix(testWord.count) ?? ""
        XCTAssertEqual(testWord, String(profileTextViewValuePrefix))

    }

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
