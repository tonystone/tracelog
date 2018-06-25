///
///  FailWhenFiredTestWriter.swift
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
import Dispatch

import TraceLog

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
