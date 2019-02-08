//
//  FileStrategyManager.swift
//  TraceLog
//
//  Created by Tony Stone on 2/1/19.
//

import Foundation

internal protocol FileStrategyManager {

    /// The URL of the currently open log file.
    ///
    var url: URL { get }

    ///
    /// Called when the Writer needs to write bytes to the output stream
    ///
    /// - Parameter bytes: The raw bytes to output.
    ///
    /// - Returns: An Int indicating the actualy number of bytes written to the output or on Failure, a FailureReason.
    ///
    func write(_ bytes: [UInt8])  -> Result<Int, FailureReason>
}

/// Maps an OutputStreamError to a Writer.FailureReason for FileOutputStream types only.
///
internal /* @testable */
extension FileStrategyManager {

    func failureReason(_ error: OutputStreamError) -> FailureReason {

        switch error {

        /// For files, these are the recoverable errors
        ///
        case .networkDown(_):  fallthrough
        case .disconnected(_): return .unavailable

        /// A file can't recover any other error type.
        ///
        default:
            return.error(error)
        }
    }
}
