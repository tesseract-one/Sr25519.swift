//
//  Helpers.swift
//  
//
//  Created by Yehor Popovych on 31.03.2021.
//

import Foundation
import XCTest

extension Data {
    init?(hex: String) {
        let hexString = hex.replacingOccurrences(of: " ", with: "").dropFirst(hex.hasPrefix("0x") ? 2 : 0)
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
    
    var hex: String {
        self.map { String(format: "%02x", $0) }.joined(separator: " ")
    }
}

extension String {
    var hexData: Data? {
        return Data(hex: self)
    }
    
    var utf8: Data {
        return data(using: .utf8)!
    }
}

@discardableResult
func AssertNoThrow<T>(_ expression: @autoclosure () throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> T? {
    var result: T? = nil
    do {
        result = try expression()
    } catch {
        XCTFail("\(error)", file: file, line: line)
    }
    return result
}

func AssertThrowsError<T>(_ expression: @autoclosure () throws -> T, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        let _ = try expression()
        XCTFail("Should throw exception", file: file, line: line)
    } catch {}
}
