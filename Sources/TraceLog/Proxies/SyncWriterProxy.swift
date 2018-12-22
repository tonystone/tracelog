///
///  SynchronousWriterProxy.swift
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
///  Created by Tony Stone on 5/27/18.
///
import Swift
import Dispatch

/// Synchronous proxy for instances of Writer.
///
internal class SyncWriterProxy: WriterProxy {

    /// The writer this class proxies.
    ///
    private let writer: Writer

    /// Serialization queue for writing
    ///
    private let queue: DispatchQueue

    internal init(writer: Writer) {
        self.writer = writer
        self.queue = DispatchQueue(label: "tracelog.write.queue.\(String(describing: writer.self))")
    }

    @inline(__always)
    internal func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        queue.sync {
            self.writer.log(timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)
        }
    }
}
