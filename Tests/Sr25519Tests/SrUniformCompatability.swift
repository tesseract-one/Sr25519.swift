//
//  SrUniformCompatabilityTests.swift
//
//
//  Created by Ruslan Rezin on 13.07.2021.
//

import XCTest
@testable import Sr25519

final class SrUniformCompatabilityTests: XCTestCase {
    let cases = [
        (
            "a36a8152d139f69b20d20c0969f6a039e360e2494a7f3c53837517fa302cd29c".hexData!,
            "49a0088c4af3af21191aeef10b0e910d7635335ed727b4f6606695180d53ca083e6e1af634b87d8963b6d2e2a595970caeefc78b821fdd1b498a3569a70ec778".hexData!,
            "fa81370fde11d045f1836f5a79e8aca0f26428d7f5f6f042d8c2708e9a041642".hexData!
        ),
        (
            "48ed48d4dddfb26cad35081b91570577ee526cd1462726c4d1872fb4f9009c0f".hexData!,
            "ff440e21bd15cc373cf36e7f3c5d50e4ea6a5469459257e37e3ddf21f9fdc70f4372a80fa95cd6b73aad634f880b40b512ee3ddd8458e13cc28c87dcc80a8996".hexData!,
            "a6f2d288398f79aeceb4e6fd0db6cc01a4ab3db866f2eb0c6cb5687802da915c".hexData!
        )
    ]

    func testGeneratedKeyInEdFormat() throws {
        try cases.forEach { testCase in
            let seed = try Sr25519Seed(raw: testCase.0)

            let uniformKeyRaw: Data = testCase.1
            let publicKeyRaw: Data = testCase.2

            let keypair = Sr25519KeyPair(seed: seed)

            let privateKeyFromUniform = try Sr25519PrivateKey(uniformRaw: uniformKeyRaw)

            XCTAssertEqual(keypair.privateKey.raw, privateKeyFromUniform.raw)
            XCTAssertEqual(uniformKeyRaw, keypair.privateKey.toUniformRaw())
            XCTAssertEqual(publicKeyRaw, keypair.publicKey.raw)
        }
    }
}

