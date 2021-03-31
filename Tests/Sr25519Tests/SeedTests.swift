//
//  SeedTests.swift
//  
//
//  Created by Yehor Popovych on 31.03.2021.
//

import XCTest
@testable import Sr25519

final class Sr25519SeedTests: XCTestCase {
    func testFromData() {
        AssertNoThrow(try Seed(seed: Data(repeating: 0, count: 32)))
        AssertThrowsError(try Seed(seed: Data(repeating: 0, count: 31)))
        AssertThrowsError(try Seed(seed: Data(repeating: 0, count: 33)))
        AssertThrowsError(try Seed(seed: Data()))
    }
    
    func testRandom() {
        XCTAssertNotEqual(Seed().data, Seed().data)
    }
}
