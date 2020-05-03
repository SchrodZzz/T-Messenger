//
//  T_MessengerTests.swift
//  T MessengerTests
//
//  Created by Suspect on 03.05.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import XCTest

@testable import T_Messenger

class TMessengerTests: XCTestCase {
    
    private var channelSorter: IChannelSorter!

    override func setUp() {
        super.setUp()
        
        channelSorter = ChannelSorter()
    }

    func testThatHasActiveSection() {
        let sorted = channelSorter.sort([])
        XCTAssertNotNil(sorted[.active])
    }
    
    func testThatHasInactiveSection() {
        let sorted = channelSorter.sort([])
        XCTAssertNotNil(sorted[.inactive])
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
