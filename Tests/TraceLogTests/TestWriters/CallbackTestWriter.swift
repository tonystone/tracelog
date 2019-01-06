///
///  CallbackTestWriter.swift
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
/// A Writer that when the log func is called, will execute your block of code passing you the values.
///
class CallbackTestWriter: Writer {
    let callback: (Double, LogLevel, String, String, RuntimeContext, StaticContext) -> Void

    init(callback: @escaping (Double, LogLevel, String, String, RuntimeContext, StaticContext) -> Void) {
        self.callback = callback
    }

    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> LogResult {
        callback(timestamp, level, tag, message, runtimeContext, staticContext)

        return .success
    }
}
