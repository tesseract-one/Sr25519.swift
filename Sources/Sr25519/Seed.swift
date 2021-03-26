//
//  Seed.swift
//  
//
//  Created by Yehor Popovych on 25.03.2021.
//

import Foundation
import CSr25519

public struct Seed: Hashable, Equatable {
    let data: Data
    
    public init() {
        try! self.init(seed: generate_seed())
    }
    
    public init(seed: Data) throws {
        guard seed.count == SR25519_SEED_SIZE else {
            throw Sr25519Error.badSeedLength(
                length: seed.count, expected: Int(SR25519_SEED_SIZE)
            )
        }
        data = seed
    }
    
    public static let size: Int = Int(SR25519_SEED_SIZE)
}


#if canImport(Security)
import Security

private func generate_seed() throws -> Data {
    var bytes = [UInt8](repeating: 0, count: Seed.size)
    let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

    guard status == errSecSuccess else {
        throw Sr25519Error.randomGeneratorError(code: Int(status))
    }
    return Data(bytes)
}

#else
import Glibc

private func generate_seed() throws -> Data {
    var bytes = [UInt8](repeating: 0, count: Seed.size)
    
    guard getentropy(&bytes, UInt(Seed.size)) == 0 else {
        throw Sr25519Error.randomGeneratorError(code: Int(errno))
    }
    
    return Data(bytes)
}
#endif
