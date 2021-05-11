//
//  Ed25519Seed.swift
//  
//
//  Created by Yehor Popovych on 07.05.2021.
//

import Foundation
#if !COCOAPODS
import CSr25519
import Sr25519Helpers
#endif

public struct Ed25519Seed: Equatable, Hashable {
    let seed: Data
    
    public init() {
        try! self.init(raw: Data(Sr25519SecureRandom.bytes(count: Self.size)))
    }
    
    public init(raw: Data) throws {
        guard raw.count == Self.size else {
            throw Ed25519Error.badSeedLength(
                length: raw.count, expected: Self.size
            )
        }
        self.seed = raw
    }
    
    public var raw: Data { seed }
    
    public static let size: Int = 32
}
