//
//  Sr25519PrivateKey.swift
//  
//
//  Created by Ruslan Rezin on 13.07.2021.
//

import Foundation
#if !COCOAPODS
import CSr25519
import Sr25519Helpers
#endif

public struct Sr25519PrivateKey {
    let key: sr25519_secret_key

    public init(raw: Data) throws {
        guard raw.count == Self.size else {
            throw Sr25519Error.badPrivateKeyLength(
                length: raw.count, expected: Self.size
            )
        }
        self.init(key: try! TCArray.new(raw: raw))
    }

    init(key: sr25519_secret_key) {
        self.key = key
    }

    init(uniformRaw: Data) throws {
        guard uniformRaw.count == Self.size else {
            throw Sr25519Error.badPrivateKeyLength(
                length: uniformRaw.count, expected: Self.size
            )
        }

        var newKey: sr25519_secret_key = TCArray.new()
        let uniformKey: sr25519_secret_key = try! TCArray.new(raw: uniformRaw)

        TCArray
            .pointer(of: (UInt8.self, UInt8.self))
            .wrap(&newKey, uniformKey) { nkp, ukp in
                sr25519_to_ed25519_bytes(nkp.baseAddress, ukp.baseAddress)
            }

        self.init(key: newKey)
    }

    public var raw: Data { TCArray.get(raw: key) }

    public func toUniformRaw() -> Data {
        var newKey: sr25519_secret_key = TCArray.new()

        TCArray
            .pointer(of: (UInt8.self, UInt8.self))
            .wrap(&newKey, key) { nkp, kp in
                sr25519_from_ed25519_bytes(nkp.baseAddress, kp.baseAddress)
            }

        return TCArray.get(raw: newKey)
    }

    public static let size: Int = MemoryLayout<sr25519_secret_key>.size
}
