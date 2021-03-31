import XCTest
@testable import Sr25519

final class Sr25519DeriveTests: XCTestCase {
    let kpData = "4c1250e05afcd79e74f6c035aee10248841090e009b6fd7ba6a98d5dc743250cafa4b32c608e3ee2ba624850b3f14c75841af84b16798bf1ee4a3875aa37a2cee661e416406384fe1ca091980958576d2bff7c461636e9f22c895f444905ea1f".hexData!
    
    func testDeriveHardKnown() {
        let cc = "14416c6963650000000000000000000000000000000000000000000000000000".hexData!
        
        let keyPair = AssertNoThrow(try KeyPair(data: kpData))
        let chainCode = AssertNoThrow(try ChainCode(code: cc))
        
        let derived = chainCode.flatMap{ keyPair?.derive(chainCode: $0, hard: true) }
        let actualPubKey = derived?.publicKey.key
        let expectedPubKey = "d8db757f04521a940f0237c8a1e44dfbe0b3e39af929eb2e9e257ba61b9a0a1a".hexData!
        XCTAssertEqual(actualPubKey, expectedPubKey)
    }
    
    func testDeriveSoftKnown() {
        let cc = "0c666f6f00000000000000000000000000000000000000000000000000000000".hexData!
        
        let keyPair = AssertNoThrow(try KeyPair(data: kpData))
        let chainCode = AssertNoThrow(try ChainCode(code: cc))
        
        let derived = chainCode.flatMap{ keyPair?.derive(chainCode: $0, hard: false) }
        let actualPubKey = derived?.publicKey.key
        let expectedPubKey = "b21e5aabeeb35d6a1bf76226a6c65cd897016df09ef208243e59eed2401f5357".hexData!
        XCTAssertEqual(actualPubKey, expectedPubKey)
    }
}
