//
//  EdKeyPairTests.swift
//  
//
//  Created by Yehor Popovych on 08.05.2021.
//

import XCTest
#if !COCOAPODS
@testable import Ed25519
#else
@testable import Sr25519
#endif

final class Ed25519KeyPairTests: XCTestCase {
    func testSeedShouldWork() {
        let seedData = "9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60".hexData!
        let expected = seedData + "d75a980182b10ab7d54bfed3c964073a0ee172f3daa62325af021a68f707511a".hexData!
        let oSeed = try? Ed25519Seed(raw: seedData)
        XCTAssertNotNil(oSeed)
        guard let seed = oSeed else { return }
        let pair = Ed25519KeyPair(seed: seed)
        XCTAssertEqual(pair.raw, expected)
    }
    
    func testSignShouldWork() {
        let seedData = "9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60".hexData!
        let oSeed = try? Ed25519Seed(raw: seedData)
        XCTAssertNotNil(oSeed)
        guard let seed = oSeed else { return }
        let pair = Ed25519KeyPair(seed: seed)
        let testPub = try? Ed25519PublicKey(raw: "d75a980182b10ab7d54bfed3c964073a0ee172f3daa62325af021a68f707511a".hexData!)
        XCTAssertEqual(pair.publicKey, testPub)
        let message = Data()
        let sigData = "e5564300c360ac729086e2cc806e828a84877f1eb8e5d974d873e065224901555fb8821590a33bacc61e39701cf9b46bd25bf5f0595bbe24655141438e7a100b".hexData!
        let oSignature = try? Ed25519Signature(raw: sigData)
        XCTAssertNotNil(oSignature)
        guard let signature = oSignature else { return }
        XCTAssertEqual(pair.sign(message: message), signature)
        XCTAssertTrue(pair.verify(message: message, signature: signature))
    }
    
    func testSignShouldWorkRawData() {
        let privKey = "1318b77fcc318fd14ca963652122591a5e46e207b3d58f6193e327d4ba7e4c1f".hexData!
        let pubKey = "7057f9906467d25dede2d5ced4050775012c9c8fae0ccbd9a50e8d7de4b2833d".hexData!
        let oPair = try? Ed25519KeyPair(raw: privKey + pubKey)
        XCTAssertNotNil(oPair)
        XCTAssertEqual(oPair, try? Ed25519KeyPair(rawSk: privKey))
        guard let pair = oPair else { return }
        let message = Data("Some awesome message to sign".utf8)
        let sigData = "7f6889fe313853bc9d8906fe713578dd5fc4f3664f079dc857315a58ffcc6620ed8b0827653c220da1052248fbbee6026cdf1beef1b821ce35f47ae83fd7180c".hexData!
        let oSignature = try? Ed25519Signature(raw: sigData)
        XCTAssertNotNil(oSignature)
        guard let signature = oSignature else { return }
        XCTAssertEqual(pair.sign(message: message), signature)
        XCTAssertTrue(pair.verify(message: message, signature: signature))
    }
    
    func testRandomShouldWork() {
        let pair = Ed25519KeyPair(seed: Ed25519Seed())
        let message = Data("Some awesome message to sign".utf8)
        let signature = pair.sign(message: message)
        XCTAssertTrue(pair.verify(message: message, signature: signature))
        XCTAssertFalse(pair.verify(message: Data("message".utf8), signature: signature))
    }
}
