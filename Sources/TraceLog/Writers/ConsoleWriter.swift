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
    /// Default constructor for this writer
    ///
    public convenience init(dateFormatter: DateFormatter = Default.dateFormatter) {
        self.init(dateFormatter: dateFormatter, fileHandle: FileHandle.standardOutput)
    }

    ///
    /// Internal constructor for this writer
    ///
    internal /* @Testable */
    init(dateFormatter: DateFormatter, fileHandle: FileHandle) {
        self.dateFormatter = dateFormatter
        self.mutex         = Mutex(.normal)
        self.output        = fileHandle
    }

    ///
    /// Required log function for the logger
    ///
    public func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        let uppercasedLevel = "\(level)".uppercased()
        let levelString     = "\(String(repeating: " ", count: 7 - uppercasedLevel.count))\(uppercasedLevel)"
        let date            = Date(timeIntervalSince1970: timestamp)
        let message         = "\(self.dateFormatter.string(from: date)) \(runtimeContext.processName)[\(runtimeContext.processIdentifier):\(runtimeContext.threadIdentifier)] \(levelString): <\(tag)> \(message)\n"

        ///
        /// Note: Since we could be called on any thread in TraceLog direct mode
        /// we protect stdout with a low-level mutex.
        ///
        /// Pthreads mutexes were chosen because out of all the methods of synchronization
        /// available in swift (queue, dispatch semaphores, etc), pthread mutexes are
        /// the lowest overhead and fastest lock.
        ///
        /// We also want to ensure we maintain thread boundaries when in direct mode (avoid
        /// jumping threads).
        ///
        mutex.lock()

        output.write(Data(message.utf8))

        mutex.unlock()
    }

    ///
    /// DateFormater being used
    ///
    private let dateFormatter: DateFormatter

    ///
    /// Low level mutex for locking print since it's not reentrent.
    ///
    private var mutex: Mutex

    ///
    /// FileHandle to write the output to.
    ///
    private let output: FileHandle
}

extension ConsoleWriter {

    ///
    /// Default values for this class.
    ///
    public enum Default {

        ///
        /// Default DateFormatter for this writer if one is not supplied.
        ///
        /// - Note: Format is "yyyy-MM-dd HH:mm:ss.SSS"
        ///
        /// - Example: "2016-04-23 10:34:26.849"
        ///
        public static let dateFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

            return formatter
        }()
    }

}

