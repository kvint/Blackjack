//
//  BlackjackTests.swift
//  BlackjackTests
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import XCTest
@testable import Blackjack

class BlackjackTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardsUniq() {
        let deck = Blackjack.CardDeck.getDeck()
        let shuffledDeck = deck.shuffled()
        
        XCTAssert(deck.count == 52)
        XCTAssert(deck.count == shuffledDeck.count)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testHandUniq() {
        for _ in 1...100 {
            let hand1 = Hand()
            let hand2 = Hand()
            XCTAssert(hand1.id != hand2.id)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
