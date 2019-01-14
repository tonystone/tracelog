///
///  StaticContextTests.swift
///
///  Copyright 2018 Tony Stone
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
///  Created by Tony Stone on 12/17/18.
///
import XCTest
import Dispatch

@testable import TraceLog

/// Test to test the StaticContext protocol and its default implementation.
///
class StaticContextTests: XCTestCase {

    func testDescription() {
        let input = TestStaticContext(file: "TestFile", function: "TestFunction", line: 23)
        let expected = "StaticContext {file: \"TestFile\", function: \"TestFunction\", line: 23}"

        XCTAssertEqual(input.description, expected)
    }
}
