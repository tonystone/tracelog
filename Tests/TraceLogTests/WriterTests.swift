///
///  WriterTests.swift
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

/// Test to test the Writer protocol and its default implementation.
///
class WriterTests: XCTestCase {

    /// The writers default value when no implementation is supplied, should be `true`.
    ///
    func testAvailableDefaultValue() {

        /// Test Writer with no available implementation.
        ///
        class TestWriter: Writer {
            func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {}
        }

        XCTAssertEqual(TestWriter().available, true)
    }
}

extension WriterTests {

    static var allTests: [(String, (WriterTests) -> () throws -> Void)] {
        return [
            ("testAvailableDefaultValue", testAvailableDefaultValue)
        ]
    }
}
