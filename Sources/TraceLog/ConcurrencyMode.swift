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
import Dispatch

/// The system wide modes that TraceLog can run in.  Used to configure a mode globally at configure time.
///
public enum ConcurrencyMode {

    /// Direct, as the name implies, will directly call the writer from
    /// the calling thread with no indirection. It will block until the
    /// writer(s) in this mode have completed the write to the endpoint.
    ///
    /// Useful for scripting applications and other applications where
    /// it is required for the call not to return until the message is
    /// printed.
    ///
    case direct

    /// Synchronous blocking mode is similar to direct in that it blocks
    /// but this mode also uses a queue for all writes.  The benefits of
    /// that is that all threads writing to the log will be serialized
    /// through before calling the writer (one call to the writer at a
    /// time).
    ///
    case sync

    /// Asynchronous non-blocking mode.  A general mode used for most
    /// application which moves processing of the write to
    /// a background queue for minimal delays when logging.
    ///
    /// - Parameter options: An array specifying the optional features to configure for each async writer that gets added.
    ///
    /// - Remark: Once Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md) is implemented
    ///           this will func will be changed to a case in the enum with default values.  We must
    ///           use a func now to work around the lack of defaults on enums.
    ///
    /// - SeeAlso: `AsyncOption` for details.
    ///
    public static func async(options: Set<AsyncOption> = []) -> ConcurrencyMode {
        return ._async(options: options)
    }

    /// The default mode used if no mode is specified (.async(options: [])).
    ///
    case `default`

    /// - Warning: Internal, don't use directly. Use func `.async(options:)` instead.
    ///            This case will be removed at the end of the beta.
    ///
    /// - Remark: This is only here to allow us to have a beta and still provide the final public interface
    ///           for `.async()` with default parameters. We currently have no way of providing default parameters to enum
    ///           cases until Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md)
    ///           is implemented.
    ///
    case _async(options: Set<AsyncOption>)
}

/// Mode to run a specific Writer in. Used to wrap a writer to change the specific mode it operates in.
///
public enum WriterConcurrencyMode {

    /// Direct, as the name implies, will directly call the writer from
    /// the calling thread with no indirection. It will block until the
    /// writer(s) in this mode have completed the write to the endpoint.
    ///
    /// Useful for scripting applications and other applications where
    /// it is required for the call not to return until the message is
    /// printed.
    ///
    /// - Parameters writer: The `Writer` instance to enable direct mode for.
    ///
    case direct(Writer)

    /// Synchronous blocking mode is similar to direct in that it blocks
    /// but this mode also uses a queue for all writes.  The benefits of
    /// that is that all threads writing to the log will be serialized
    /// through before calling the writer (one call to the writer at a
    /// time).
    ///
    /// - Parameters writer: The `Writer` instance to enable sync mode for.
    ///
    case sync(Writer)

    /// Asynchronous non-blocking mode.  A general mode used for most
    /// application which moves processing of the write to
    /// a background queue for minimal delays when logging.
    ///
    /// - Parameters:
    ///     - writer: The `Writer` instance to enable async mode for.
    ///     - options: An array specifying the optional features to configure for the `writer`.
    ///
    /// - Remark: Once Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md) is implemented
    ///           this will func will be changed to a case in the enum with default values.  We must
    ///           use a func now to work around the lack of defaults on enums.
    ///
    /// - SeeAlso: `AsyncOption` for details.
    ///
    public static func async(_ writer: Writer, options: Set<AsyncOption> = []) -> WriterConcurrencyMode {
        return ._async(writer, options: options)
    }

    /// - Warning: Internal, don't use directly. Use func `.async(_:options:)` instead.
    ///            This case will be removed at the end of the beta.
    ///
    /// - Remark: This is only here to allow us to have a beta and still provide the final public interface
    ///           for `.async()` with default parameters. We currently have no way of providing default parameters to enum
    ///           cases until Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md)
    ///           is implemented.
    ///
    case _async(Writer, options: Set<AsyncOption>)
}

///
/// Async mode can be configured for various options, this enum allows you to refine the
/// behavior and options of the asynchronous mode of operation.
///
public enum AsyncOption {

    /// Back the async mode with a buffer for when the writer is not `available` to
    /// write to it's endpoint.  Useful for situations where the endpoint may not
    /// be available at all times.
    ///
    /// Whenever the writer returns false for `available` TraceLog will buffer the
    /// log entries until the endpoint is `available`. It will check the writer for
    /// availability based on the `writeInterval` parameter. Once available, TraceLog
    /// will write each log entry in the buffer (in order) until the end of the
    /// buffer or the Writer becomes unavailable again.
    ///
    /// Buffering is useful for many different use case including:
    ///
    /// E.g. In an iOS application when protected data is not available to your
    ///      app but you require visibility into the apps logging even during
    ////     these times.
    ///
    ///      A network writer when the network connection is unavailable for any reason.
    ///
    /// - Parameters:
    ///     - writeInternal: if the writer is currently buffering, TraceLog will periodically check whether the writer is available and write if it is.  This is the time frame between checks.
    ///     - strategy: The buffer strategy to use when buffering.
    ///
    public static func buffer(writeInterval: DispatchTimeInterval = .seconds(60), strategy: BufferStrategy = .dropTail(at: 1000)) -> AsyncOption {
        return ._buffer(writeInterval: writeInterval, strategy: strategy)
    }

    /// A BufferStrategy is the action the internal
    /// buffer will take when a new log entry is logged
    /// but the buffer is at it's limit (maxSize).
    ///
    public enum BufferStrategy {

        /// If dropTail is used, when the buffer is filled
        /// to its maximum capacity, the newly arriving log
        /// entries are dropped until the buffer has
        /// enough room to accept incoming entries.
        ///
        /// - Parameter at: start dropping log entries when this number of entries is reached in the buffer.
        ///
        case dropTail(at: Int)

        /// If dropHead is used, when the buffer is filled
        /// to its maximum capacity, the oldest entry (head)
        /// is dropped to make room for the newly arriving log
        /// entry.
        ///
        /// - Parameter at: start dropping log entries when this number of entries is reached in the buffer.
        ///
        case dropHead(at: Int)

        /// If expand is set, the buffer will continue
        /// to expand until the available memory is exhausted.
        ///
        case expand
    }

    /// - Warning: Internal, don't use directly. Use func `.buffer(writeInterval:strategy:)` instead.
    ///            This case will be removed at the end of the beta.
    ///
    /// - Remark: This is only here to allow us to have a beta and still provide the final public interface
    ///           for `.buffer(writeInterval:strategy:)` with default parameters. We currently have no way of providing default parameters to enum
    ///           cases until Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md)
    ///           is implemented.
    ///
    case _buffer(writeInterval: DispatchTimeInterval, strategy: BufferStrategy)
}

extension AsyncOption: Equatable, Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case ._buffer(_,_):
            hasher.combine(1)
        }
    }

    public static func == (lhs: AsyncOption, rhs: AsyncOption) -> Bool {
        switch (lhs, rhs) {
        case (._buffer(_,_), ._buffer(_,_)): return true
        }
    }
}

///
/// Internal ConcurrencyMode extension.
///
internal extension ConcurrencyMode {

    /// Internal func to convert a `ConcurrencyMode` to a `WriterConcurrencyMode`.
    ///
    func writerMode(for writer: Writer) -> WriterConcurrencyMode {
        switch self {
            case .direct:               return .direct(writer)
            case .sync:                 return .sync  (writer)
            case ._async(let options):  return ._async(writer, options: options)
            default:                    return ._async(writer, options: [])
        }
    }
}

///
/// Internal WriterConcurrencyMode extension.
///
internal extension WriterConcurrencyMode {

    func proxy() -> WriterProxy {
        switch self {
            case .direct(let writer):               return DirectWriterProxy(writer: writer)
            case .sync  (let writer):               return SyncWriterProxy  (writer: writer)
            case ._async (let writer, let options): return AsyncWriterProxy (writer: writer, options: options)

        }
    }
}
