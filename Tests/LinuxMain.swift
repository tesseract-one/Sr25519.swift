import XCTest

import Ed25519Tests
import Sr25519Tests

var tests = [XCTestCaseEntry]()
tests += Ed25519Tests.__allTests()
tests += Sr25519Tests.__allTests()

XCTMain(tests)
