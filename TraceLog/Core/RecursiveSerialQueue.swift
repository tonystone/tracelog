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
    
    static  var queueID = 1
    
    private let queue: dispatch_queue_t
    private let context: UnsafeMutablePointer<Void>
    
    init (name: String) {
        queue = dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL)
        context = UnsafeMutablePointer<Void>(Unmanaged<dispatch_queue_t>.passUnretained(queue).toOpaque())
        
        dispatch_queue_set_specific(queue, &RecursiveSerialQueue.queueID, context, nil)
    }
    
    func performBlockAndWait (block: () -> Void) {
        
        if dispatch_get_specific(&RecursiveSerialQueue.queueID) == context {
            block()
        } else {
            dispatch_sync(queue, block)
        }
    }
}