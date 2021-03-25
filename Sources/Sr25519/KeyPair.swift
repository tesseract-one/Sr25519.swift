//
//  KeyPair.swift
//  
//
//  Created by Yehor Popovych on 25.03.2021.
//

import Foundation
import CSr25519

public struct KeyPair: Hashable, Equatable {
    private let _private: Data
    private let _public: PublicKey
    
    public init(seed: Seed) {
        var data = [UInt8](repeating: 0, count: Self.size)
        seed.data.withUnsafeBytes { bytes in
            sr25519_keypair_from_seed(
                &data, bytes.bindMemory(to: UInt8.self).baseAddress
            )
        }
        try! self.init(data: Data(data))
    }
    
    public init(data: Data) throws {
        guard data.count == Self.size else {
            throw Sr25519Error.badKeyPairLength(
                length: data.count, expected: Self.size
            )
        }
        _private = Data(data[0..<Self.secretSize])
        _public = try PublicKey(data: Data(data[Self.secretSize..<Self.size]))
    }
    
    public var publicKey: PublicKey { _public }
    
    public func derive(chainCode: ChainCode, hard: Bool) -> KeyPair {
        var out = [UInt8](repeating: 0, count: Self.size)
        var pair = keyPair
        chainCode.code.withUnsafeBytes { cc in
            let ccptr = cc.bindMemory(to: UInt8.self).baseAddress
            if hard {
                sr25519_derive_keypair_hard(&out, &pair, ccptr)
            } else {
                sr25519_derive_keypair_soft(&out, &pair, ccptr)
            }
        }
        return try! KeyPair(data: Data(out))
    }
    
    public func sign(message: Data) -> Signature {
        var out = [UInt8](repeating: 0, count: Signature.size)
        message.withUnsafeBytes { mes in
            self._private.withUnsafeBytes { privk in
                self._public.key.withUnsafeBytes { pubk in
                    let pubptr = pubk.bindMemory(to: UInt8.self).baseAddress
                    let privptr = privk.bindMemory(to: UInt8.self).baseAddress
                    let message = mes.bindMemory(to: UInt8.self)
                    sr25519_sign(
                        &out, pubptr, privptr, message.baseAddress, UInt(message.count)
                    )
                }
            }
        }
        return try! Signature(signature: Data(out))
    }
    
    public func verify(message: Data, signature: Signature) -> Bool {
        _public.verify(message: message, signature: signature)
    }
    
    public func vrfSign(message: Data, ifLessThan limit: VrfThreshold) throws -> VrfSignature {
        var out = [UInt8](repeating: 0, count: VrfSignature.size)
        var pair = keyPair
        let res = message.withUnsafeBytes { mes in
            limit.data.withUnsafeBytes { limit -> VrfResult in
                let message = mes.bindMemory(to: UInt8.self)
                let limptr = limit.bindMemory(to: UInt8.self).baseAddress
                return sr25519_vrf_sign_if_less(&out, &pair, message.baseAddress, UInt(message.count), limptr)
            }
        }
        guard res.result == Ok && res.is_less else {
            throw Sr25519Error.vrfError(code: res.result.rawValue)
        }
        return try VrfSignature(data: Data(out))
    }
    
    public func vrfVerify(message: Data, signature: VrfSignature, threshold: VrfThreshold) throws -> Bool {
        try _public.vrfVerify(message: message, signature: signature, threshold: threshold)
    }
    
    private var keyPair: [UInt8] {
        var pair = [UInt8]()
        pair.reserveCapacity(Self.size)
        pair.append(contentsOf: _private)
        pair.append(contentsOf: _public.key)
        return pair
    }
    
    public static let size: Int = Int(SR25519_KEYPAIR_SIZE)
    public static let secretSize: Int = Int(SR25519_SECRET_SIZE)
}
