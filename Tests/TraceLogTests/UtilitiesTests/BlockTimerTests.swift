///
///  BlockTimerTests.swift
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

class BlockTimerTests: XCTestCase {

    let queue = DispatchQueue(label: "Test Queue")

    /// Force the code to dealloc to excersize the dealloc method.
    ///
    func testDealloc() {

        let spin = XCTestExpectation(description: "spin")
        spin.isInverted = true

        do {
            let timer = BlockTimer(deadline: .now(), repeating: .milliseconds(250), queue: self.queue)
            timer.resume()
        }

        self.wait(for: [spin], timeout: 1)
    }

    /// Test that the timer repeatedly calls the handler after resume.
    ///
    func testRepeatFire() {

        let fired = XCTestExpectation(description: "did fire")
        fired.expectedFulfillmentCount = 5

        let timer = BlockTimer(deadline: .now(), repeating: .milliseconds(100), queue: self.queue)
        timer.handler = {
            fired.fulfill()
        }
        timer.resume()

        self.wait(for: [fired], timeout: 1)
    }

    func testSuspendResume() {

        let fired = XCTestExpectation(description: "fired")
        fired.expectedFulfillmentCount = 1

        let timer = BlockTimer(deadline: .now(), repeating: .milliseconds(100), queue: self.queue)
        timer.handler = {
            fired.fulfill()
        }
        timer.resume()

        /// Mske sure it fires
        self.wait(for: [fired], timeout: 1)

        /// Now make sure we can suspend again.
        ///
        let suspended = XCTestExpectation(description: "suspended")
        suspended.isInverted = true

        timer.handler = {
            suspended.fulfill()
        }

        timer.suspend()

        /// Mske sure it does not fire.
        ///
        /// Note that the wait time will wait 10 cycles.
        ///
        self.wait(for: [suspended], timeout: 1)

        /// Now make sure we can continue.
        ///
        let resumed = XCTestExpectation(description: "resumed")
        resumed.expectedFulfillmentCount = 5

        timer.handler = {
            resumed.fulfill()
        }

        timer.resume()

        /// Mske sure it fires repeatedly again.
        ///
        /// Note that the wait time will wait 10 cycles.
        ///
        self.wait(for: [resumed], timeout: 1)

    }

    func testResumeWhenResumed() {

        let fired = XCTestExpectation(description: "did fire")
        fired.expectedFulfillmentCount = 8

        let timer = BlockTimer(deadline: .now(), repeating: .milliseconds(100), queue: self.queue)
        timer.handler = {
            fired.fulfill()
        }

        for _ in 1...10 {
            timer.resume()
        }

        self.wait(for: [fired], timeout: 1)
    }

    func testSuspendWhenSuspended() {

        let fired = XCTestExpectation(description: "did fire")
        fired.isInverted = true

        let timer = BlockTimer(deadline: .now(), repeating: .milliseconds(100), queue: self.queue)
        timer.handler = {
            fired.fulfill()
        }

        for _ in 1...10 {
            timer.suspend()
        }

        self.wait(for: [fired], timeout: 1)
    }
}

extension BlockTimerTests {

    static var allTests: [(String, (BlockTimerTests) -> () throws -> Void)] {
        return [
            ("testDealloc", testDealloc),
            ("testRepeatFire", testRepeatFire),
            ("testSuspendResume", testSuspendResume),
            ("testResumeWhenResumed", testResumeWhenResumed),
            ("testSuspendWhenSuspended", testSuspendWhenSuspended)
        ]
    }
}
