///
///  ExpectationValues.swift
///  TraceLog
///
///  Created by Tony Stone on 10/6/16.
///  Copyright © 2016 Tony Stone. All rights reserved.
///
import XCTest
import Foundation
import Dispatch

import TraceLog

///
/// Log Writer which captures the expected value and fulfills the XCTestExpectation when it matches the message
///
class ExpectationValues: Writer {

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

///
/// No result Writer
///
class FailWhenFiredWriter: Writer {

    let semaphore: DispatchSemaphore

    init(semaphore: DispatchSemaphore) {
        self.semaphore = semaphore
    }

    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        semaphore.signal()
    }
}
