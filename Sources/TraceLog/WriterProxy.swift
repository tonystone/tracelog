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
/// Internal proxy which executes writers accourding to the mode.
///
internal class WriterProxy: Writer {

    static func newProxy(for writer: Writer, mode: Mode) -> WriterProxy {
        if mode == .sync {
            return SynchronousWriterProxy(writer: writer)
        }
        return AsynchronousWriterProxy(writer: writer)
    }

    ///
    /// Serialization queue for init and writing
    ///
    let queue: DispatchQueue

    let writer: Writer

    fileprivate init(writer: Writer) {
        self.writer = writer
        self.queue = DispatchQueue(label: "tracelog.write.queue.\(String(describing: writer.self))")
    }

    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {}
}

private class SynchronousWriterProxy: WriterProxy {

    @inline(__always)
    override func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        queue.sync {
            self.writer.log(timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)
        }
    }
}

private class AsynchronousWriterProxy: WriterProxy {

    @inline(__always)
    override func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        queue.async {
            self.writer.log(timestamp, level: level, tag: tag, message: message, runtimeContext: runtimeContext, staticContext: staticContext)
        }
    }
}
