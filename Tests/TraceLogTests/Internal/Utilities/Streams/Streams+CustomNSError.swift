///
///  Streams+CustomNSError.swift
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
///  Created by Tony Stone on 2/8/19.
///

/// When testing or using classes from Objective-C we need to convert the errors to something understandable by that runtime.
///
#if canImport(ObjectiveC)
import Foundation

@testable import TraceLog

extension OutputStreamError: CustomNSError {

    public static var errorDomain: String {
        return "FileOutputStream.Error"
    }

    public var errorCode: Int {
        switch self {
        case .networkDown(_):
            return -1
        case .disconnected(_):
            return -2
        case .insufficientResources(_):
            return -3
        case .accessDenied(_):
            return -4
        case .invalidArgument(_):
            return -5
        case .unknownError(let code, _):
            return Int(code)
        }
    }

    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: "\(self)"]
    }
}

extension FileOutputStreamError: CustomNSError {

    public static var errorDomain: String {
        return "FileOutputStream.Error"
    }

    public var errorCode: Int {
        switch self {
        case .fileExists(_):
            return -1
        case .accessDenied(_):
            return -2
        case .invalidURL(_):
            return -3
        case .unknownError(let code, _):
            return Int(code)
        }
    }

    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: "\(self)"]
    }
}

#endif
