/**
 *   RecursiveSerialQueue.swift
 *
 *   Copyright 2016 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Created by Tony Stone on 4/28/16.
 */
import Foundation

internal class RecursiveSerialQueue {
    
    fileprivate let queue: DispatchQueue
    fileprivate var queueID = DispatchSpecificKey<String>()
    fileprivate let context: String
    
    init (name: String) {
        self.context = name
        self.queue   = DispatchQueue(label: name, attributes: [])
        
        self.queue.setSpecific(key: self.queueID, value: context)
    }
    
    func performBlockAndWait (_ block: () -> Void) {
        
        if DispatchQueue.getSpecific(key: self.queueID) == context {
            block()
        } else {
            queue.sync(execute: block)
        }
    }
}
