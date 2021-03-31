//
//  PublicKey.swift
//  
//
//  Created by Yehor Popovych on 25.03.2021.
//

import Foundation
import CSr25519

public struct PublicKey: Hashable, Equatable {
    public let key: Data
    
    public init(data: Data) throws {
        guard data.count == Self.size else {
            throw Sr25519Error.badPublicKeyLength(
                length: data.count, expected: Self.size
            )
        }
        key = data
    }
    
    public func verify(message: Data, signature: Signature) -> Bool {
        key.withUnsafeBytes { key in
            signature.data.withUnsafeBytes { sig in
                message.withUnsafeBytes { mes in
                    let keyptr = key.bindMemory(to: UInt8.self).baseAddress
                    let sigptr = sig.bindMemory(to: UInt8.self).baseAddress
                    let message = mes.bindMemory(to: UInt8.self)
                    return sr25519_verify(
                        sigptr, message.baseAddress, UInt(message.count), keyptr
                    )
                }
            }
        }
    }
    
    public func derive(chainCode: ChainCode) -> PublicKey {
        var out = [UInt8](repeating: 0, count: Self.size)
        key.withUnsafeBytes { key in
            let keyptr = key.bindMemory(to: UInt8.self).baseAddress
            chainCode.code.withUnsafeBytes { cc in
                let ccptr = cc.bindMemory(to: UInt8.self).baseAddress
                sr25519_derive_public_soft(&out, keyptr, ccptr)
            }
        }
        return try! PublicKey(data: Data(out))
    }
    
    public static let size: Int = Int(SR25519_PUBLIC_SIZE)
}
