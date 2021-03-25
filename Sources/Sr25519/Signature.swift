//
//  Signature.swift
//  
//
//  Created by Yehor Popovych on 25.03.2021.
//

import Foundation
import CSr25519

public struct Signature: Hashable, Equatable {
    public let data: Data
    
    public init(signature: Data) throws {
        guard signature.count == Self.size else {
            throw Sr25519Error.badSignatureLength(
                length: signature.count,
                expected: Self.size
            )
        }
        self.data = signature
    }
    
    public func verify(for message: Data, key: PublicKey) -> Bool {
        key.verify(message: message, signature: self)
    }
    
    public func verify(for message: Data, pair: KeyPair) -> Bool {
        pair.verify(message: message, signature: self)
    }
    
    public static let size: Int = Int(SR25519_SIGNATURE_SIZE)
}


