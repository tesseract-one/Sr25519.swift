//
//  Vrf.swift
//  
//
//  Created by Yehor Popovych on 25.03.2021.
//

import Foundation
import CSr25519

public struct VrfSignature: Hashable, Equatable {
    public let output: Data
    public let proof: Data
    
    public init(data: Data) throws {
        guard data.count == Self.size else {
            throw Sr25519Error.badVrfSignatureLength(
                length: data.count, expected: Self.size
            )
        }
        try self.init(
            output: Data(data[0..<Self.outputSize]),
            proof: Data(data[Self.outputSize..<Self.size])
        )
    }
    
    public init(output: Data, proof: Data) throws {
        guard output.count == Self.outputSize else {
            throw Sr25519Error.badVrfOutputLength(
                length: output.count, expected: Self.outputSize
            )
        }
        guard proof.count == Self.proofSize else {
            throw Sr25519Error.badVrfProofLength(
                length: proof.count, expected: Self.proofSize
            )
        }
        self.output = output
        self.proof = proof
    }
    
    public func verify(for message: Data, key: PublicKey, threshold: VrfThreshold) -> Bool {
        key.vrfVerify(message: message, signature: self, threshold: threshold)
    }
    
    public func verify(for message: Data, pair: KeyPair, threshold: VrfThreshold) -> Bool {
        pair.vrfVerify(message: message, signature: self, threshold: threshold)
    }
    
    internal func withRawData<T>(
        f: @escaping (UnsafePointer<UInt8>?, UnsafePointer<UInt8>?) throws -> T
    ) rethrows -> T {
        try output.withUnsafeBytes { out in
            try proof.withUnsafeBytes { proof in
                try f(
                    out.bindMemory(to: UInt8.self).baseAddress,
                    proof.bindMemory(to: UInt8.self).baseAddress
                )
            }
        }
    }
    
    public var data: Data { output + proof }
    
    public static let size: Int = outputSize + proofSize
    public static let outputSize: Int = Int(SR25519_VRF_OUTPUT_SIZE)
    public static let proofSize: Int = Int(SR25519_VRF_PROOF_SIZE)
}

public struct VrfThreshold: Hashable, Equatable {
    public let data: Data
    
    public init() {
        try! self.init(data: Data(repeating: 0xFF, count: Self.size))
    }
    
    public init(data: Data) throws {
        guard data.count == Self.size else {
            throw Sr25519Error.badVrfThresholdLength(
                length: data.count, expected: Self.size
            )
        }
        self.data = data
    }
    
    public static let size: Int = Int(SR25519_VRF_THRESHOLD_SIZE)
}


extension KeyPair {
    public func vrfSign(message: Data, ifLessThan limit: VrfThreshold) throws -> (signature: VrfSignature, isLess: Bool) {
        var out = [UInt8](repeating: 0, count: VrfSignature.size)
        var pair = keyPair
        let res = message.withUnsafeBytes { mes in
            limit.data.withUnsafeBytes { limit -> VrfResult in
                let message = mes.bindMemory(to: UInt8.self)
                let limptr = limit.bindMemory(to: UInt8.self).baseAddress
                return sr25519_vrf_sign_if_less(&out, &pair, message.baseAddress, UInt(message.count), limptr)
            }
        }
        guard res.result == Ok else {
            throw Sr25519Error.vrfError(code: res.result.rawValue)
        }
        return try (VrfSignature(data: Data(out)), res.is_less)
    }
    
    public func vrfVerify(message: Data, signature: VrfSignature, threshold: VrfThreshold) -> Bool {
        publicKey.vrfVerify(message: message, signature: signature, threshold: threshold)
    }
}

extension PublicKey {
    public func vrfVerify(message: Data, signature: VrfSignature, threshold: VrfThreshold) -> Bool {
        let res = key.withUnsafeBytes { key in
             message.withUnsafeBytes { mes in
                threshold.data.withUnsafeBytes { thr in
                    signature.withRawData { (output, proof) -> VrfResult in
                        let keyptr = key.bindMemory(to: UInt8.self).baseAddress
                        let message = mes.bindMemory(to: UInt8.self)
                        let thrptr = thr.bindMemory(to: UInt8.self).baseAddress
                        return sr25519_vrf_verify(
                            keyptr, message.baseAddress, UInt(message.count),
                            output, proof, thrptr
                        )
                    }
                }
            }
        }
        return res.result == Ok && res.is_less
    }
}
