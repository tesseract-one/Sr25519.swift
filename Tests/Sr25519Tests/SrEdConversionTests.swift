//
//  SrEdConversionTests.swift
//  
//
//  Created by Ruslan Rezin on 13.07.2021.
//

import XCTest
@testable import Sr25519

final class SrEdConversionTests: XCTestCase {
    let cases = [
        (
            "70e1ddf7edfc4a98423a4cdfdd51e4529d228840e6e30e25f1d3502250a8055c7677a385ccf0bddfb2bafbdec086bcd2475dc46aeafad822d27e1f901eb9b278".hexData!,
            "2ebcfbbe9d5f09534887e9bb3b8a5caa530411c87cdca1247e1a4a040ab5800b7677a385ccf0bddfb2bafbdec086bcd2475dc46aeafad822d27e1f901eb9b278".hexData!
        ),
        (
            "28b0ae221c6bb06856b287f60d7ea0d98552ea5a16db16956849aa371db3eb51fd190cce74df356432b410bd64682309d6dedb27c76845daf388557cbac3ca34".hexData!,
            "05d65584630d16cd4af6d0bec10f34bb504a5dcb62dba2122d49f5a663763d0afd190cce74df356432b410bd64682309d6dedb27c76845daf388557cbac3ca34".hexData!
        )
    ]

    func testKeyInEdFormatToUniformConversion() throws {
        try cases.forEach { testCase in
            let ed25519Raw: Data = testCase.0

            let uniformRaw: Data = testCase.1

            let privateKeyFromRaw = AssertNoThrow(try Sr25519PrivateKey(raw: ed25519Raw))
            let privateKeyFromUniform = AssertNoThrow(try Sr25519PrivateKey(uniformRaw: uniformRaw))

            XCTAssertEqual(privateKeyFromUniform?.raw.hex, privateKeyFromRaw?.raw.hex)
            XCTAssertEqual(uniformRaw, privateKeyFromRaw?.toUniformRaw())
        }
    }
}

