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
        let keyPair = KeyPair(seed: Seed())
        let message = "Hello, World!".data(using: .utf8)!
        let limit = VrfThreshold()
        let signature = AssertNoThrow(try keyPair.vrfSign(message: message, ifLessThan: limit))
        
        if let signature = signature {
            let valid1 = keyPair.vrfVerify(message: message, signature: signature.signature, threshold: limit)
            XCTAssertEqual(valid1, true)
            
            var sigData = signature.signature.data
            sigData[5] += 3
            if let signature = AssertNoThrow(try VrfSignature(data: sigData)) {
                let valid2 = keyPair.vrfVerify(message: message, signature: signature, threshold: limit)
                XCTAssertEqual(valid2, false)
            }
        }
    }
    
    func testResultNotLess() {
        let keyPair = AssertNoThrow(try KeyPair(data: kpData))
        XCTAssertNotNil(keyPair)
        let message = "Hello, world!".data(using: .utf8)!
        let limit = try? VrfThreshold(data: Data(repeating: 0x55, count: VrfThreshold.size))
        XCTAssertNotNil(limit)
        
        if let limit = limit, let keyPair = keyPair {
            let signature = AssertNoThrow(try keyPair.vrfSign(message: message, ifLessThan: limit))
            XCTAssertEqual(signature?.isLess, false)
        }
    }
    
    func testSignAndCheck() {
        let keyPair = AssertNoThrow(try KeyPair(data: kpData))
        XCTAssertNotNil(keyPair)
        let message = "Hello, world!".data(using: .utf8)!
        let limit = try? VrfThreshold(data: Data(repeating: 0xAA, count: VrfThreshold.size))
        XCTAssertNotNil(limit)
        
        if let limit = limit, let keyPair = keyPair {
            let signature = AssertNoThrow(try keyPair.vrfSign(message: message, ifLessThan: limit))
            XCTAssertEqual(signature?.isLess, true)
        }
    }
}


