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
        XCTAssertTrue(Environment().count > 0)
    }

    func testInit_DictionaryLiteral() {
        let input: Environment = ["TEST_VAR1": "Value1", "TEST_VAR2": "Value2"]

        XCTAssertEqual(input.count, 2)
    }

    func testInit_CollectionType() {
        let input = Environment(["TEST_VAR1": "Value1", "TEST_VAR2": "Value2"])

        XCTAssertEqual(Environment(input).count, 2)
    }

    func testSubscript() {
        let environment = Environment()

        environment["TEST_VAR1"] = "Value1"
        XCTAssertEqual(environment["TEST_VAR1"], "Value1")
    }
}

extension EnvironmentTests {

   static var allTests: [(String, (EnvironmentTests) -> () throws -> Void)] {
      return [
                ("testInit", testInit),
                ("testInit_DictionaryLiteral", testInit_DictionaryLiteral),
                ("testInit_CollectionType", testInit_CollectionType),
                ("testSubscript", testSubscript)
           ]
   }
}
