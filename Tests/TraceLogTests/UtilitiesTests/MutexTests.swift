///
///  MutexTests.swift
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
///  Created by Tony Stone on 7/01/2018.
///
import XCTest
import Dispatch

@testable import TraceLog

class MutexTests: XCTestCase {

    func testLockUnlock() {
        let group = DispatchGroup()

        let mutex = Mutex(.normal)
        mutex.lock()    /// Initially lock the mutex

        for _ in 0..<10 {
            DispatchQueue.global().async(group: group) {
                mutex.lock()   /// Lock and unlock the mutex, we should block until the main thread unlocks the mutex
                mutex.unlock()
            }
        }
        mutex.unlock()  /// Unlock the mutex allowing the thread to continue
        XCTAssertEqual(group.wait(timeout: .now() + 0.1), .success)
    }

    func testLockUnlockRecursive() {
        let group = DispatchGroup()

        let mutex = Mutex(.recursive)
        mutex.lock()    /// Initially lock the mutex

        for _ in 0..<10 {
            DispatchQueue.global().async(group: group) {
                mutex.lock()    /// Lock the mutex, we should block until the main thread unlocks the mutex
                mutex.lock()    /// Inner (recursive) lock should succeed since this is a recursive mutex

                mutex.unlock()
                mutex.unlock()
            }
        }
        mutex.unlock()  /// Unlock the mutex allowing the thread to continue
        XCTAssertEqual(group.wait(timeout: .now() + 0.1), .success)
    }

    func testLockUnlockNonRecursiveBlocked() {
        let mutex = Mutex(.normal)

        /// Lock and unlock the mutex
        mutex.lock()
        defer { mutex.unlock() }

        XCTAssertFalse(mutex.tryLock()) /// Inner (recursive) tryLock should fail since this is not a recursive mutex
    }

    func testLockBlocked() {
        let group = DispatchGroup()

        let mutex = Mutex(.normal)
        mutex.lock()    /// Initially lock the mutex

        for _ in 0..<10 {
            DispatchQueue.global().async(group: group) {
                /// Lock and unlock the mutex, we should block until the main thread unlocks the mutex
                mutex.lock()
                mutex.unlock()
            }
        }
        /// Do not unlock the mutex forcing the timeout to happen
        XCTAssertEqual(group.wait(timeout: .now() + 0.1), .timedOut)
        mutex.unlock()  /// Cleanup
    }

    func testTryLockBlocked() {
        let group = DispatchGroup()

        let mutex = Mutex(.normal)
        mutex.lock()    /// Initially lock the mutex

        for _ in 0..<10 {
            DispatchQueue.global().async(group: group) {
                /// Lock and unlock the mutex, this should fail (return false) but not block
                XCTAssertFalse(mutex.tryLock())
            }
        }
        /// Do not unlock the mutex
        XCTAssertEqual(group.wait(timeout: .now() + 0.1), .success)
        mutex.unlock()  /// Cleanup
    }
}


extension MutexTests {
   static var allTests: [(String, (MutexTests) -> () throws -> Void)] {
      return [
                ("testLockUnlock", testLockUnlock),
                ("testLockUnlockRecursive", testLockUnlockRecursive),
                ("testLockUnlockNonRecursiveBlocked", testLockUnlockNonRecursiveBlocked),
                ("testLockBlocked", testLockBlocked),
                ("testTryLockBlocked", testTryLockBlocked)
           ]
   }
}
