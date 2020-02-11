///
///  FileStrategy+Fixed.swift
///
///  Copyright 2019 Tony Stone
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
///  Created by Tony Stone on 1/31/19.
///
import Foundation

@available(iOSApplicationExtension, unavailable)
internal class FileStrategyFixed: FileStrategyManager {

    let url: URL

    private var stream: FileOutputStream
    private var available: Bool

    init(directory: URL, fileName: String) throws {

        self.url       = directory.appendingPathComponent(fileName)
        self.available = isLogAvailable()
        self.stream    = try FileOutputStream(url: url, options: [.create])

        #if os(iOS) && !targetEnvironment(simulator)
        /// Note: You can create empty files with file protection in any state.  You just cant write or read from them.
        ///       We can safely create the file and set it's protection level even if not available.
        ///
        try FileManager.default.setAttributes([.protectionKey : FileProtectionType.completeUntilFirstUserAuthentication], ofItemAtPath: url.path)

        if !available {
            NotificationCenter.default.addObserver(forName: UIApplication.protectedDataDidBecomeAvailableNotification, object: nil, queue: nil) { (_) in
                if !self.available {
                    self.available = true
                }
            }
        }
        #endif
    }
    deinit {
        self.stream.close()
    }

    func write(_ bytes: [UInt8]) -> Result<Int, FailureReason> {

        guard self.available
            else { return .failure(.unavailable) }

        return stream.write(bytes).mapError({ self.failureReason($0) })
    }
}

#if os(iOS) && !targetEnvironment(simulator) && !targetEnvironment(macCatalyst)
import UIKit

@available(iOSApplicationExtension, unavailable)
func isLogAvailable() -> Bool {
    if !Thread.isMainThread {
        return DispatchQueue.main.sync {
            return UIApplication.shared.isProtectedDataAvailable
        }
    }
    return UIApplication.shared.isProtectedDataAvailable
}
#else

func isLogAvailable() -> Bool {
    return true
}
#endif
