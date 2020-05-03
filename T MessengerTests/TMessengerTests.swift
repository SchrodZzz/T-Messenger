//
//  T_MessengerTests.swift
//  T MessengerTests
//
//  Created by Suspect on 03.05.2020.
//  Copyright © 2020 Andrey Ivshin. All rights reserved.
//

import XCTest
import CoreData

@testable import T_Messenger

extension Channel {
    static func fixture(_ lastActivity: Date?, _ name: String) -> Channel? {
        guard let entity = NSEntityDescription.entity(forEntityName: "Channel", in: CoreDataStack.shared.saveContext) else { return nil }
        let channel = Channel(entity: entity, insertInto: nil)
        channel.lastActivity = lastActivity
        channel.name = name
        return channel
    }
}

class TMessengerTests: XCTestCase {
    
    private var channelSorter: IChannelSorter!
    private var mockData: [Channel]!

    override func setUp() {
        super.setUp()
        
        channelSorter = ChannelSorter()
        
        let tmpMockData: [Channel?] = [.fixture(Date(timeIntervalSince1970: 0), "1970"),
                .fixture(Date(timeIntervalSinceNow: -60.0 * 60.0), "hourAgo"),
                .fixture(Date(), "now"),
                .fixture(nil, "nil")]
        mockData = tmpMockData.compactMap { $0 }
    }

    func testThatHasActiveSection() {
        // When
        let sorted = channelSorter.sort([])
        
        // Then
        XCTAssertNotNil(sorted[.active])
    }
    
    func testThatHasInactiveSection() {
        // When
        let sorted = channelSorter.sort([])
        
        // Then
        XCTAssertNotNil(sorted[.inactive])
    }
    
    func testThatSortedByDate() {
        // Given
        let expectedResult = ["nil", "now", "hourAgo", "1970"]
        
        // When
        let result = channelSorter.sort(mockData).values.flatMap { $0 }.map { $0.name }
        
        // Then
        XCTAssertEqual(expectedResult, result)
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
