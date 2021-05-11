//
//  VrfTests.swift
//  
//
//  Created by Yehor Popovych on 31.03.2021.
//

import XCTest
@testable import Sr25519

final class Sr25519VrfTests: XCTestCase {
    
    let kpData = "915bb406968655c3412df5773c3de3dee9f6da84668b5de8d2f34d0304d20b0bac5ea3a293dfd93859ee64a5b825937753864c19be857f045758dcae10259ba1049b21bb9cb88471b9dadb50b925135cfb291a463043635b58599a2d01b1fd18".hexData!
    
    func testVerify() {
        let keyPair = Sr25519KeyPair(seed: Sr25519Seed())
        let message = "Hello, World!".data(using: .utf8)!
        let limit = Sr25519VrfThreshold()
        let signature = AssertNoThrow(try keyPair.vrfSign(message: message, ifLessThan: limit))
        
        if let signature = signature {
            let valid1 = keyPair.vrfVerify(message: message, signature: signature.signature, threshold: limit)
            XCTAssertEqual(valid1, true)
            
            var sigData = signature.signature.raw
            sigData[5] = UInt8(clamping: UInt16(sigData[5]) + 3)
            if let signature = AssertNoThrow(try Sr25519VrfSignature(raw: sigData)) {
                let valid2 = keyPair.vrfVerify(message: message, signature: signature, threshold: limit)
                XCTAssertEqual(valid2, false)
            }
        }
    }
    
    func testSignAndCheck() {
        let keyPair = AssertNoThrow(try Sr25519KeyPair(raw: kpData))
        XCTAssertNotNil(keyPair)
        let message = "Hello, world!".data(using: .utf8)!
        let limit = try? Sr25519VrfThreshold(raw: Data(repeating: 0xAA, count: Sr25519VrfThreshold.size))
        XCTAssertNotNil(limit)
        
        if let limit = limit, let keyPair = keyPair {
            let signature = AssertNoThrow(try keyPair.vrfSign(message: message, ifLessThan: limit))
            XCTAssertEqual(signature?.isLess, true)
        }
    }
}


