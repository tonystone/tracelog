///
///  AsynchronousWriterProxy.swift
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
///  Created by Tony Stone on 12/10/18.
///
import Foundation

/// A fault tolerant buffer backed writer proxy for instances of Writer.
///
/// This proxy will write directly to the writer unless the writer is
/// unavailable (can't write to it's end point), in this case, it buffers
/// the messages until they can be written.
///
internal class AsyncWriterProxy: WriterProxy {

    /// The writer this class proxies.
    ///
    private let writer: Writer

    /// Serialization queue for writing
    ///
    private let queue: DispatchQueue

    /// If buffering is enabled, this will
    /// contain the buffer queue and the
    /// write timer to write out the queue.
    ///
    private var buffer: (queue: LogEntryQueue, writeTimer: BlockTimer)?

    /// Initialize the proxy with the proxied Writer and any options to configure.
    ///
    internal init(writer: Writer, options: [AsyncOption]) {
        self.writer = writer
        self.queue  = DispatchQueue(label: "tracelog.write.queue.\(String(describing: writer.self))")

        for option in options {
            switch option {

            /// Enable buffering
            case .buffer(let writeInterval, let strategy):

                let writeTimer = BlockTimer(deadline: .now() + writeInterval, repeating: writeInterval, queue: self.queue)
                writeTimer.handler = { [weak self] in

                    self?.queue.async {
                        self?.writeBuffer()
                    }
                }

                /// Enable buffering setting up the queue and writeTimer
                ///
                self.buffer = (queue: LogEntryQueue(for: strategy), writeTimer: writeTimer)
            }
        }
    }

    @inline(__always)
    internal func write(_ entry: Writer.LogEntry) {

        self.queue.async {

            /// If buffering is not enabled, simply write and return the writers value.
            ///
            guard let buffer = self.buffer
                else {
                    self.writer.write(entry)
                    return
            }

            /// Append the log entry to the memory buffer.  The queue strategy will
            /// determine what ultimately happens to the entry.
            ///
            buffer.queue.enqueue(entry)

            /// Attempt to write the entries in the buffer.
            ///
            self.writeBuffer()

            /// If the buffer was not completely written, resume the
            /// the write timer so that the writer will attempt again
            /// on the next write interval.
            ///
            if !buffer.queue.isEmpty {
                buffer.writeTimer.resume()
            }
        }
    }

    /// Write the buffer out if available to the endpoint.
    ///
    /// - Note: this method requires synchronization by the caller.
    ///
    private func writeBuffer() {

        guard let buffer = self.buffer
            else { return }

        /// If the writer is available, read and log all message
        /// (in order) from the buffer.
        ///
        for _ in 1...buffer.queue.count {

            let entry = buffer.queue.peek()

            switch self.writer.write(entry) {

            case .success:
                _ = buffer.queue.dequeue(); continue
            case .failed(let reason):
                switch reason {
                    case .unavailable: break
                    default: break
                }
                break
            }
        }

        /// If we got through all of them, it's safe to
        /// suspend the writer, it will be started again
        /// on the first new entry that gets queued.
        ///
        if buffer.queue.isEmpty {
            buffer.writeTimer.suspend()
        }
    }
}

/// A LogEntryQueue is a FIFO queue that uses variable
/// strategies for limiting (or not limiting) the buffer
/// size and dropping entries as appropriate.
///
private class LogEntryQueue {

    /// The strategy this queue instance is using to queue items.
    ///
    private let strategy: AsyncOption.BufferStrategy

    ///
    /// Internal storage for this buffer.
    ///
    private var storage: [Writer.LogEntry] = []

    init(for strategy: AsyncOption.BufferStrategy) {
        self.strategy = strategy
    }

    /// Is the queue empty?
    ///
    public var isEmpty: Bool {
        return storage.isEmpty
    }

    /// Is the queue empty?
    ///
    public var isFull: Bool {
        switch strategy {
            case .dropTail(let limit): return storage.count >= limit
            case .dropHead(let limit): return storage.count >= limit
            case .expand:              return false
        }
    }

    /// Count of current items in the queue
    ///
    public var count: Int {
        return storage.count
    }

    /// Count of dropped log entries.
    ///
    private(set) public var dropped: Int = 0

    /// Add an item to the queue if it can be added.
    ///
    public func enqueue(_ element: Writer.LogEntry) {
        switch strategy {

        case .dropTail(let limit):      /// Drop if we are at or above the limit.
            if storage.count >= limit {
                dropped += 1
                return
            }
        case .dropHead(let limit):      /// Remove the oldest at the head of the queue.
            if storage.count >= limit {
                dropped += 1
                storage.remove(at: 0)
            }
        case .expand:                   /// Allow the queue to expand.
            break
        }

        /// Now add the new element
        storage.append(element)
    }

    /// Remove the first item from the queue
    ///
    public func dequeue() -> Writer.LogEntry {
        return storage.remove(at: 0)
    }

    /// Retrieves, but does not remove, the head of this queue, or returns nil if this queue is empty.
    ///
    public func peek() -> Writer.LogEntry {
        return storage[0]
    }
}

