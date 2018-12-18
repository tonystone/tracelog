///
///  TestContext.swift
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
import TraceLog


internal class TestRuntimeContext: RuntimeContext {

    internal let processName: String
    internal let processIdentifier: Int
    internal let threadIdentifier: UInt64

    internal init(processName: String = "TestProcess", processIdentifier: Int = 100, threadIdentifier: UInt64 = 1100) {
        self.processName       = processName
        self.processIdentifier = processIdentifier
        self.threadIdentifier  = threadIdentifier
    }
}

internal class TestStaticContext: StaticContext {

    public let file: String
    public let function: String
    public let line: Int

    internal init(file: String = #file, function: String = #function, line: Int = #line) {
        self.file       = file
        self.function   = function
        self.line       = line
    }
}
