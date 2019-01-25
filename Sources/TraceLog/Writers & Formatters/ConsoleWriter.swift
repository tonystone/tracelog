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
public class ConsoleWriter: OutputStreamWriter {

    /// OutputStreamFormatter being used for formating output.
    ///
    public let format: OutputStreamFormatter

    /// Default constructor for this writer
    ///
    public convenience init(format: OutputStreamFormatter = TextFormat()) {
        self.init(outputStream: Standard.out, format: format)
    }

    /// Internal constructor for this writer
    ///
    internal /* @Testable */
    init(outputStream: OutputStream, format: OutputStreamFormatter) {
        self.outputStream = outputStream
        self.format       = format
        self.mutex        = Mutex(.normal)
    }

    /// Required write function for the logger
    ///
    public func write(_ entry: Writer.LogEntry) -> Result<Int, FailureReason> {

        guard case .success(let bytes) = format.bytes(from: entry)
            else { return .failure(.error("Formatting failed."))  }

        /// Note: Since we could be called on any thread in TraceLog direct mode
        /// we protect the outputStream with a low-level mutex.
        ///
        /// PThreads Mutexes were chosen because out of all the methods of synchronization
        /// available in swift (queue, dispatch semaphores, etc), PThread Mutexes are
        /// the lowest overhead and fastest lock.
        ///
        /// We also want to ensure we maintain thread boundaries when in direct mode (avoid
        /// jumping threads).
        ///
        mutex.lock(); defer { mutex.unlock() }

        switch self.outputStream.write(bytes) {

            case .success(_):


                if written == bytes.count {
                    return .success(())
                }
                return .failure(.error("Only able to write \(written) of \(bytes.count) bytes to OutputStream."))
            case .failure(let error):
                return .failure(.error(error.localizedDescription))
        }
    }

    /// Low level mutex for locking print since it's not reentrant.
    ///
    private var mutex: Mutex

    /// FileHandle to write the output to.
    ///
    private var outputStream: OutputStream
}