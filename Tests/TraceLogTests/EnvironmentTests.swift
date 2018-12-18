///
///  EnvironmentTests.swift
///
///  Copyright 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 10/5/16.
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
