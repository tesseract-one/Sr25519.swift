import XCTest

import Sr25519Tests

var tests = [XCTestCaseEntry]()
tests += Sr25519Tests.__allTests()

XCTMain(tests)
