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
        let expectedResult = ["now", "nil", "hourAgo", "1970"]
        
        // When
        let sorted = channelSorter.sort(mockData)
        let activeChannels = sorted[.active] ?? []
        let inactiveChannels = sorted[.inactive] ?? []
        let flatMapOfValues = activeChannels + inactiveChannels
        let result = flatMapOfValues.map { $0.name }
        
        // Then
        XCTAssertEqual(expectedResult, result)
    }
    
    func testThatSeparatedIntoStates() {
        // Given
        let expectedResult: [ChannelState: [String]] = [.active: ["now"],
                                                        .inactive: ["nil", "hourAgo", "1970"]]
        
        // When
        let sorted = channelSorter.sort(mockData)
        let result = sorted.mapValues { $0.map { $0.name } }
        
        // Then
        XCTAssertEqual(expectedResult, result)
    }

}
