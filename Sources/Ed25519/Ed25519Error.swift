//
//  Ed25519Error.swift
//  
//
//  Created by Yehor Popovych on 07.05.2021.
//

import Foundation

public enum Ed25519Error: Error, Equatable, Hashable {
    case badSeedLength(length: Int, expected: Int)
    case badKeyPairLength(length: Int, expected: Int)
    case badPublicKeyLength(length: Int, expected: Int)
    case badPrivateKeyLength(length: Int, expected: Int)
    case badSignatureLength(length: Int, expected: Int)
}
