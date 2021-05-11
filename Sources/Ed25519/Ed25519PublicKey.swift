//
//  Ed25519PublicKey.swift
//  
//
//  Created by Yehor Popovych on 07.05.2021.
//

import Foundation
#if !COCOAPODS
import CSr25519
import Sr25519Helpers
#endif

public struct Ed25519PublicKey {
    let key: ed25519_public_key
    
    public init(raw: Data) throws {
        guard raw.count == Self.size else {
            throw Ed25519Error.badPublicKeyLength(
                length: raw.count, expected: Self.size
            )
        }
        self.init(key: try! TCArray.new(raw: raw))
    }
    
    init(key: ed25519_public_key) {
        self.key = key
    }
    
    public var raw: Data {
        TCArray.get(raw: key)
    }
    
    public func verify(message: Data, signature: Ed25519Signature) -> Bool {
        TCArray
            .pointer(of: (UInt8.self, UInt8.self))
            .wrap(key, signature.signature) { kp, sp in
                message.withUnsafeBytes { mes -> Bool in
                    let message = mes.bindMemory(to: UInt8.self)
                    return ed25519_sign_open(
                        message.baseAddress, message.count, kp.baseAddress, sp.baseAddress
                    ) == 0
                }
            }
    }
    
    public static let size: Int = MemoryLayout<ed25519_public_key>.size
}

extension Ed25519PublicKey: Equatable {
    public static func == (lhs: Ed25519PublicKey, rhs: Ed25519PublicKey) -> Bool {
        TCArray.equal(lhs.key, rhs.key)
    }
}

extension Ed25519PublicKey: Hashable {
    public func hash(into hasher: inout Hasher) {
        TCArray.hash(key, in: &hasher)
    }
}
