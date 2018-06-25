///
///  ValidateExpectedValuesTestWriter.swift
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
///  Created by Tony Stone on 6/20/18.
///
import XCTest
import Foundation

import TraceLog

///
/// Log Writer which captures the expected value and fulfills the XCTestExpectation when it matches the message
///
class ValidateExpectedValuesTestWriter: Writer {

    let expectation: XCTestExpectation

    let level: LogLevel
    let tag: String
    let message: String
    let file: String
    let function: String
    let testFileFunction: Bool

    init(expectation: XCTestExpectation, level: LogLevel, tag: String, message: String, file: String = #file, function: String = #function, testFileFunction: Bool = true) {
        self.expectation = expectation
        self.level = level
        self.tag = tag
        self.message = message
        self.file = file
        self.function = function
        self.testFileFunction = testFileFunction
    }

    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        if level == self.level &&
            tag == self.tag &&
            message == self.message {

            if !testFileFunction ||
                staticContext.file == self.file &&
                staticContext.function == self.function {
                expectation.fulfill()
            }
        }
    }
}
