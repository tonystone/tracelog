///
///  WriterProxy.swift
///  Pods
///
///  Created by Tony Stone on 5/27/18.
///
///
import Swift
import Dispatch

///
/// Synchronous proxy for instances of Writer.
///
internal class SynchronousWriterProxy: Writer {

    private let writer: Writer

    ///
    /// Serialization queue for init and writing
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

///
/// Asynchronous proxy for instances of Writer.
///
internal class AsynchronousWriterProxy: Writer {

    private let writer: Writer

    ///
    /// Serialization queue for init and writing
    ///
    private let queue: DispatchQueue

    internal init(writer: Writer) {
        self.writer = writer
        self.queue = DispatchQueue(label: "tracelog.write.queue.\(String(describing: writer.self))")
    }

    @inline(__always)
    internal func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        queue.async {
            self.writer.log(timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)
        }
    }
}

