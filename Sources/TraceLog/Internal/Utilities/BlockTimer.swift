///
///  BlockTimer.swift
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
///  Created by Tony Stone on 12/17/18.
///
import Swift
import Dispatch

///
/// Repeating utility timer.
///
internal /* @testable */
class BlockTimer {

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
        self.timer.cancel()

        self.resume()
    }

    var handler: (() -> Void)? {
        willSet {
            self.timer.setEventHandler(handler: newValue)
        }
    }

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
