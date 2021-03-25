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
    
    public func verify(for message: Data, key: PublicKey, threshold: VrfThreshold) throws -> Bool {
        try key.vrfVerify(message: message, signature: self, threshold: threshold)
    }
    
    public func verify(for message: Data, pair: KeyPair, threshold: VrfThreshold) throws -> Bool {
        try pair.vrfVerify(message: message, signature: self, threshold: threshold)
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
