//
//  ChainCode.swift
//  
//
//  Created by Yehor Popovych on 25.03.2021.
//

import Foundation
import CSr25519

public struct ChainCode: Hashable, Equatable {
    public let code: Data
    
    public init(code: Data) throws {
        guard code.count == Self.size else {
            throw Sr25519Error.badChainCodeLength(
                length: code.count,
                expected: Self.size
            )
        }
        self.code = code
    }
    
    public static let size: Int = Int(SR25519_CHAINCODE_SIZE)
}
