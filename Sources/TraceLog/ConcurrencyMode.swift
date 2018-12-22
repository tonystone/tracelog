///
///  ConcurrencyMode+Extensions.swift
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
///  Created by Tony Stone on 5/12/18.
///
import Swift

///
/// The system wide modes that TraceLog can run in.  Used to configure a mode globally at configure time.
///
public enum ConcurrencyMode {

    ///
    /// Direct, as the name implies, will directly call the writer from
    /// the calling thread with no indirection. It will block until the
    /// writer(s) in this mode have completed the write to the endpoint.
    ///
    /// Useful for scripting applications and other applications where
    /// it is required for the call not to return until the message is
    /// printed.
    ///
    case direct

    ///
    /// Synchronous blocking mode is similer to direct in that it blocks
    /// but this mode also uses a queue for all writes.  The benefits of
    /// that is that all threads writing to the log will be serialized
    /// through before calling the writer (one call to the writer at a
    /// time).
    ///
    case sync

    ///
    /// Asynchronous non-blocking mode.  A general mode used for most
    /// application which queues all messages before being evaluated or logged.
    /// This ensures minimal delays in application execution due to logging.
    ///
    case async

    ///
    /// The default mode used if no mode is specified (.async).
    ///
    case `default`
}

///
/// Mode to run a specific Writer in. Used to wrap a writer to change the specific mode it operates in.
///
public enum WriterConcurrencyMode {

    ///
    /// Direct, as the name implies, will directly call the writer from
    /// the calling thread with no indirection. It will block until the
    /// writer(s) in this mode have completed the write to the endpoint.
    ///
    /// Useful for scripting applications and other applications where
    /// it is required for the call not to return until the message is
    /// printed.
    ///
    case direct(Writer)

    ///
    /// Synchronous blocking mode is simaler to direct in that it blocks
    /// but this mode also uses a queue for all writes.  The benifits of
    /// that is that all threads writing to the log will be serialized
    /// through before calling the writer (one call to the writer at a
    /// time).
    ///
    case sync(Writer)

    ///
    /// Asynchronous non-blocking mode.  A general mode used for most
    /// application which queues all messages before being evaluated or logged.
    /// This ensures minimal delays in application execution due to logging.
    ///
    case async(Writer)
}

///
/// Internal ConcurrencyMode extension.
///
internal extension ConcurrencyMode {

    ///
    /// Internal func to convert a `ConcurrencyMode` to a `WriterConcurrencyMode`.
    ///
    func writerMode(for writer: Writer) -> WriterConcurrencyMode {
        switch self {
            case .direct: return .direct(writer)
            case .sync:   return .sync(writer)
            default:      return .async(writer)
        }
    }
}

///
/// Internal WriterConcurrencyMode extension.
///
internal extension WriterConcurrencyMode {

    func proxy() -> Writer {
        switch self {
            case .direct(let writer):  return writer
            case .sync(let writer):    return SynchronousWriterProxy(writer: writer)
            case .async(let writer):   return AsynchronousWriterProxy(writer: writer)
        }
    }
}
