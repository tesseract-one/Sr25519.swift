//
//  Ed25519Signature.swift
//  
//
//  Created by Yehor Popovych on 07.05.2021.
//

import Foundation
#if !COCOAPODS
import CSr25519
import Sr25519Helpers
#endif

public struct Ed25519Signature {
    let signature: ed25519_signature
    
    public init(raw: Data) throws {
        guard raw.count == Self.size else {
            throw Ed25519Error.badSignatureLength(
                length: raw.count,
                expected: Self.size
            )
        }
        self.init(signature: try! TCArray.new(raw: raw))
    }
    
    init(signature: ed25519_signature) {
        self.signature = signature
    }
    
    public var raw: Data {
        TCArray.get(raw: signature)
    }
    
    public func verify(for message: Data, key: Ed25519PublicKey) -> Bool {
        key.verify(message: message, signature: self)
    }

    public func verify(for message: Data, pair: Ed25519KeyPair) -> Bool {
        pair.verify(message: message, signature: self)
    }
    
    public static let size: Int = MemoryLayout<ed25519_signature>.size
}

extension Ed25519Signature: Equatable {
    public static func == (lhs: Ed25519Signature, rhs: Ed25519Signature) -> Bool {
        TCArray.equal(lhs.signature, rhs.signature)
    }
}

extension Ed25519Signature: Hashable {
    public func hash(into hasher: inout Hasher) {
        TCArray.hash(signature, in: &hasher)
    }
}
