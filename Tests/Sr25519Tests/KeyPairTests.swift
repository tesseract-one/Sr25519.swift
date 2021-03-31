//
//  KeyPairTests.swift
//  
//
//  Created by Yehor Popovych on 31.03.2021.
//

import XCTest
@testable import Sr25519

final class Sr25519KeyPairTests: XCTestCase {
    let cases = [
        (Data(repeating: 0, count: 32), "caa835781b15c7706f65b71f7a58c807ab360faed6440fb23e0f4c52e930de0a0a6a85eaa642dac835424b5d7c8d637c00408c7a73da672b7f498521420b6dd3def12e42f3e487e9b14095aa8d5cc16a33491f1b50dadcf8811d1480f3fa8627".hexData!),
        ("12345678901234567890123456789012".data(using: .utf8)!, "1ec20c6cb85bf4c7423b95752b70c312e6ae9e5701ffb310f0a9019d9c041e0af98d66f39442506ff947fd911f18c7a7a5da639a63e8d3b4e233f74143d951c1741c08a06f41c596608f6774259bd9043304adfa5d3eea62760bd9be97634d63".hexData!),
        ("fac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e".hexData!,
         "05d65584630d16cd4af6d0bec10f34bb504a5dcb62dba2122d49f5a663763d0afd190cce74df356432b410bd64682309d6dedb27c76845daf388557cbac3ca3446ebddef8cd9bb167dc30878d7113b7e168e6f0646beffd77d69d39bad76b47a".hexData!)
    ]
    
    private func randomKeyPair() -> KeyPair? {
        cases.randomElement().flatMap { (_, kpData) in
            try? KeyPair(data: kpData)
        }
    }
    
    func testKeyPairFromSeed() {
        for (seedData, expected) in cases {
            let seed = AssertNoThrow(try Seed(seed: seedData))
            let kp = seed.flatMap{KeyPair(seed: $0)}
            XCTAssertEqual(kp?.keyPair, Array(expected))
        }
    }
    
    func testSignAndVerifyValid() {
        let keyPair = randomKeyPair()
        let message = "hello world".data(using: .utf8)!
        XCTAssertNotNil(keyPair)
        
        let signature = keyPair?.sign(message: message)
        let valid = keyPair.flatMap { kp in
            signature.flatMap { sig in
                (kp, sig)
            }
        }.map {$0.0.verify(message: message, signature: $0.1)}
        XCTAssertEqual(valid, true)
    }
    
    func testSignAndVerifyInvalid() {
        let keyPair = randomKeyPair()
        let message = "hello world".data(using: .utf8)!
        XCTAssertNotNil(keyPair)
        
        let signature = (keyPair?.sign(message: message)).flatMap { sig in
            try? Signature(signature: Data([0]) + sig.data.suffix(Signature.size-1))
        }
        XCTAssertNotNil(signature)
        
        let valid = keyPair.flatMap { kp in
            signature.flatMap { sig in
                (kp, sig)
            }
        }.map {$0.0.verify(message: message, signature: $0.1)}
        XCTAssertEqual(valid, false)
    }
    
    func testVerifyExtisting() {
        let pubKeyData = "46ebddef8cd9bb167dc30878d7113b7e168e6f0646beffd77d69d39bad76b47a".hexData!
        let message = "this is a message".data(using: .utf8)!
        let sigData = "4e172314444b8f820bb54c22e95076f220ed25373e5c178234aa6c211d29271244b947e3ff3418ff6b45fd1df1140c8cbff69fc58ee6dc96df70936a2bb74b82".hexData!
        
        let pubKey = AssertNoThrow(try PublicKey(data: pubKeyData))
        let signature = AssertNoThrow(try Signature(signature: sigData))
        let valid = signature.flatMap { pubKey?.verify(message: message, signature: $0) }
        XCTAssertEqual(valid, true)
    }
}

