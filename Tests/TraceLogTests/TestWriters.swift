///
///  ValidateExpectedValuesWriter.swift
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
/// Null Writer that sleeps for the passed in time when a message is recieved.
///
class SleepyWriter: Writer {
    let sleepTime: useconds_t

    init(sleepTime: useconds_t) {
        self.sleepTime = sleepTime
    }

    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        usleep(sleepTime)
    }
}

///
/// A Writer that when the log func is called, will execute your block of code passing you the values.
///
class CallbackWriter: Writer {
    let callback: (Double, LogLevel, String, String, RuntimeContext, StaticContext) -> Void

    init(callback: @escaping (Double, LogLevel, String, String, RuntimeContext, StaticContext) -> Void) {
        self.callback = callback
    }

    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        callback(timestamp, level, tag, message, runtimeContext, staticContext)
    }
}

///
/// Log Writer which captures the expected value and fulfills the XCTestExpectation when it matches the message
///
class ValidateExpectedValuesWriter: Writer {

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
