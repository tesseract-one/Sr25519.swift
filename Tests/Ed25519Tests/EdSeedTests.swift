//
//  EdSeedTests.swift
//  
//
//  Created by Yehor Popovych on 11.05.2021.
//

import XCTest
#if !COCOAPODS
@testable import Ed25519
#else
@testable import Sr25519
#endif

final class Ed25519SeedTests: XCTestCase {
    func testFromData() {
        XCTAssertNoThrow(try Ed25519Seed(raw: Data(repeating: 0, count: 32)))
        XCTAssertThrowsError(try Ed25519Seed(raw: Data(repeating: 0, count: 31)))
        XCTAssertThrowsError(try Ed25519Seed(raw: Data(repeating: 0, count: 33)))
        XCTAssertThrowsError(try Ed25519Seed(raw: Data()))
    }
    
    func testRandom() {
        XCTAssertNotEqual(Ed25519Seed().raw, Ed25519Seed().raw)
    }
}
