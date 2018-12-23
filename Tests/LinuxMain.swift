import XCTest

import TraceLogTestHarnessTests
import TraceLogTests

var tests = [XCTestCaseEntry]()
tests += TraceLogTestHarnessTests.__allTests()
tests += TraceLogTests.__allTests()

XCTMain(tests)
