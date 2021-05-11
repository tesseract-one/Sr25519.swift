//
//  Ed25519ChainCode.swift
//  
//
//  Created by Yehor Popovych on 07.05.2021.
//

import Foundation
#if !COCOAPODS
import CSr25519
import Sr25519Helpers
#endif

public struct Ed25519ChainCode: Equatable, Hashable {
    let code: Data
    
    public var raw: Data { code }
    
    public init(raw: Data) throws {
        guard raw.count == Self.size else {
            throw Ed25519Error.badChainCodeLength(
                length: raw.count,
                expected: Self.size
            )
        }
        self.code = raw
    }
    
    public static let size: Int = 32
}
