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
        AssertNoThrow(try Sr25519Seed(raw: Data(repeating: 0, count: 32)))
        AssertThrowsError(try Sr25519Seed(raw: Data(repeating: 0, count: 31)))
        AssertThrowsError(try Sr25519Seed(raw: Data(repeating: 0, count: 33)))
        AssertThrowsError(try Sr25519Seed(raw: Data()))
    }
    
    func testRandom() {
        XCTAssertNotEqual(Sr25519Seed().raw, Sr25519Seed().raw)
    }
}
