//
//  SrDeriveTests.swift
//
//
//  Created by Yehor Popovych on 31.03.2021.
//

import XCTest
@testable import Sr25519

final class Sr25519DeriveTests: XCTestCase {    
    func testDeriveHardKnown() {
        let cc = "14416c6963650000000000000000000000000000000000000000000000000000".hexData!
        let seedData = "fac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e".hexData!
        let seed = AssertNoThrow(try Sr25519Seed(raw: seedData))
        let keyPair = seed.map { Sr25519KeyPair(seed: $0) }
        let chainCode = AssertNoThrow(try Sr25519ChainCode(raw: cc))
        
        let derived = chainCode.flatMap{ keyPair?.derive(chainCode: $0, hard: true) }
        let actualPubKey = derived?.publicKey.raw
        let expectedPubKey = "d43593c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56da27d"
        XCTAssertEqual(actualPubKey?.hex, expectedPubKey)
    }
    
    func testDeriveSoftKnown() {
        let cc = "0c666f6f00000000000000000000000000000000000000000000000000000000".hexData!
        let seedData = "b8f820bb54c22e95076f220ed25373e5c178234aa6c211d29271244b947e3ff3".hexData!
        let seed = AssertNoThrow(try Sr25519Seed(raw: seedData))
        let keyPair = seed.map { Sr25519KeyPair(seed: $0) }
        let chainCode = AssertNoThrow(try Sr25519ChainCode(raw: cc))
        
        let derived = chainCode.flatMap{ keyPair?.derive(chainCode: $0, hard: false) }
        let actualPubKey = derived?.publicKey.raw
        let expectedPubKey = "6ad6672fd4270be979cfe2e58955ce015fec7b68580db3d5c4955c7570ccb170"
        XCTAssertEqual(actualPubKey?.hex, expectedPubKey)
    }
}
