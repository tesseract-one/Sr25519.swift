//
//  SrKeyPairTests.swift
//  
//
//  Created by Yehor Popovych on 31.03.2021.
//

import XCTest
@testable import Sr25519

final class Sr25519KeyPairTests: XCTestCase {
    let cases = [
        (Data(repeating: 0, count: 32), "def12e42f3e487e9b14095aa8d5cc16a33491f1b50dadcf8811d1480f3fa8627"),
        ("12345678901234567890123456789012".data(using: .utf8)!, "741c08a06f41c596608f6774259bd9043304adfa5d3eea62760bd9be97634d63"),
        ("b8f820bb54c22e95076f220ed25373e5c178234aa6c211d29271244b947e3ff3".hexData!,
         "92ea19a4dcd694e8c39c3276c11da59049a91cd527e99777f47181a480a61c1d"),
        ("fac7959dbfe72f052e5a0c3c8d6530f202b02fd8f9f5ca3580ec8deb7797479e".hexData!,
         "46ebddef8cd9bb167dc30878d7113b7e168e6f0646beffd77d69d39bad76b47a")
    ]
    
    private func randomKeyPair() -> Sr25519KeyPair? {
        cases.randomElement().flatMap { (seed, _) in
            try? Sr25519KeyPair(seed: Sr25519Seed(raw: seed))
        }
    }
    
    func testKeyPairFromSeed() {
        for (seedData, pubData) in cases {
            let seed = AssertNoThrow(try Sr25519Seed(raw: seedData))
            let kp = seed.flatMap{Sr25519KeyPair(seed: $0)}
            XCTAssertEqual(kp?.publicKey.raw.hex, pubData)
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
            try? Sr25519Signature(raw: Data([0]) + sig.raw.suffix(Sr25519Signature.size-1))
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
        
        let pubKey = AssertNoThrow(try Sr25519PublicKey(raw: pubKeyData))
        let signature = AssertNoThrow(try Sr25519Signature(raw: sigData))
        let valid = signature.flatMap { pubKey?.verify(message: message, signature: $0) }
        XCTAssertEqual(valid, true)
    }
}

