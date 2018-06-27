///
///  ConsoleWriter.swift
///
///  Copyright 2016 Tony Stone
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
///  Created by Tony Stone on 4/23/16.
///
import Foundation

///
/// ConsoleWriter is the default `Writer` in **TraceLog** and writes to stdout.
///
/// This writer will be installed for you if you do not set any other writer's
/// at configuration time.  Its a basic writer that can be used at any time that
/// you want the output to go to the stdout.
///
public class ConsoleWriter: Writer {

    ///
    /// Low level mutex for locking print since it's not reentrent.
    ///
    private var mutex: Mutex

    ///
    /// Default constructor for this writer
    ///
    public init() {
        self.mutex = Mutex(.recursive)
    }

    ///
    /// Required log function for the logger
    ///
    public func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        let uppercasedLevel = "\(level)".uppercased()
        let levelString     = "\(String(repeating: " ", count: 7 - uppercasedLevel.count))\(uppercasedLevel)"
        let date            = Date(timeIntervalSince1970: timestamp)
        let message         = "\(self.dateFormatter.string(from: date)) \(runtimeContext.processName)[\(runtimeContext.processIdentifier):\(runtimeContext.threadIdentifier)] \(levelString): <\(tag)> \(message)"

        ///
        /// Note: Since we could be called on any thread in TraceLog direct mode
        /// we protect the print statement with a low-level mutex.
        ///
        /// Pthreads mutexes were chosen because out of all the methods of synchronization
        /// available in swift (queue, dispatch semaphores, etc), pthread mutexes are
        /// the lowest overhead and fastest lock.
        ///
        /// We also want to ensure we maintain thread boundaries when in direct mode (avoid
        /// jumping threads).
        ///
        mutex.lock()

        print(message)

        mutex.unlock()
    }

    ///
    /// Internal date formatter for this logger
    ///
    private let dateFormatter: DateFormatter = {

        var formatter = DateFormatter()

        /// 2016-04-23 10:34:26.849
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

        return formatter
    }()
}
