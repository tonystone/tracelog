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


///
/// A fault tolerant buffer backed writer proxy for instances of Writer.
///
/// This proxy will write directly to the writer unless the writer is
/// unavailable (can't write to it's end point), in this case, it's buffers
/// the messages until they can be written.
///
internal class AsyncWriterProxy: Writer {

    ///
    /// The writer this class proxies.
    ///
    private let writer: Writer

    ///
    /// Serialization queue for writing
    ///
    private let queue: DispatchQueue

    ///
    /// If buffering is enabled, this will
    /// contain the buffer queue and the
    /// write timer to write out the queue.
    ///
    private var buffer: (queue: LogEntryQueue, writeTimer: BlockTimer)?

    ///
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
                        guard !writeTimer.isCancelled
                            else {
                                return
                        }
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
    internal func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        self.queue.async {

            /// If buffering is not enabled, simply write and return.
            ///
            guard let buffer = self.buffer
                else {
                    self.writer.log(timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)
                    return
            }

            /// Append the log entry to the memory buffer.  The queue strategy will
            /// determine what ultimately happens to the entry.
            ///
            buffer.queue.enqueue((timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext))

            self.writeBuffer()

            /// Resume the buffer writer if the buffer has any entries left after the write.
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
        for _ in 0..<buffer.queue.count {

            if !self.writer.available {
                break  /// Stop on the first entry that cannot be written.
            }
            let entry = buffer.queue.dequeue()

            self.writer.log(entry.timestamp, level: entry.level, tag: entry.tag, message: entry.message, runtimeContext: entry.runtimeContext, staticContext: entry.staticContext)
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

///
/// A LogEntryQueue is a FIFO queue that uses variable
/// strategies for limiting or not the buffer size and
/// dropping entries as appropriate.
///
private class LogEntryQueue {

    typealias Element = (timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext)
    typealias Index = Int

    /// The strategy this queue instance is using to queue items.
    ///
    private let strategy: AsyncOption.BufferStrategy

    ///
    /// Internal storage for this buffer.
    ///
    private var storage: [Element] = []

    init(for strategy: AsyncOption.BufferStrategy) {
        self.strategy = strategy
    }

    /// Is the queue empty?
    ///
    public var isEmpty: Bool {
        return storage.isEmpty
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
    public func enqueue(_ element: Element) {
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
    public func dequeue() -> Element {
        return storage.remove(at: 0)
    }
}

///
/// Repeating utility timer.
///
private class BlockTimer {

    ///
    /// Internal state.
    ///
    private enum State {
        case suspended
        case resumed
    }
    private var state: State = .suspended

    private let timer: DispatchSourceTimer

    init(deadline: DispatchTime, repeating: DispatchTimeInterval, queue: DispatchQueue? = nil) {
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        self.timer.schedule(deadline: deadline, repeating: repeating)
    }

    deinit {
        self.timer.setEventHandler {}
        self.timer.cancel()

        self.resume()
    }

    var handler: (() -> Void)? {
        willSet {
            self.timer.setEventHandler(handler: newValue)
        }
    }

    var isCancelled: Bool { return timer.isCancelled }

    func resume() {
        guard state == .suspended
            else { return }

        state = .resumed
        timer.resume()
    }

    func suspend() {
        guard state == .resumed
            else { return }

        state = .suspended
        timer.suspend()
    }
}
