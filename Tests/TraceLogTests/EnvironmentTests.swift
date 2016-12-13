///
///  EnvironmentTests.swift
///  TraceLog
///
///  Created by Tony Stone on 10/5/16.
///  Copyright © 2016 Tony Stone. All rights reserved.
///

import XCTest
@testable import TraceLog

class EnvironmentTests: XCTestCase {

    func testInit() {
        XCTAssertTrue(Environment().count > 0)   /// Note: Assumes there will be something set in the environment.
    }

    func testInit_DictionaryLiteral() {
        XCTAssertEqual(Environment(["TEST_VAR1" : "Value1", "TEST_VAR2" : "Value2"]).count, 2)
    }

    func testInit_CollectionType() {
        XCTAssertEqual(Environment(Environment(["TEST_VAR1" : "Value1", "TEST_VAR2" : "Value2"])).count, 2)
    }

    func testSubscript() {
        let environment = Environment()

        environment["TEST_VAR1"] = "Value1"
        XCTAssertEqual(environment["TEST_VAR1"], "Value1")
    }
}
