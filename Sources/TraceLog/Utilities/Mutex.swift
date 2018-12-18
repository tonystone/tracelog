///
///  Mutex.swift
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
///  Created by Tony Stone on 6/27/18.
///
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux) || os(FreeBSD) || os(PS4) || os(Android)  /* Swift 5 support: || os(Cygwin) || os(Haiku) */
    import Glibc
#endif

///
/// Mutually Exclusive Lock (Mutex) implementation.
///
internal class Mutex {

    ///
    /// The type of mutex to create.
    ///
    public enum MutexType {
        /// Lower overhead mutex that does not allow recursion.
        case normal

        /// Allows recursion but incurs overhead due to having to keep track fo the calling thread.
        case recursive
    }

    ///
    /// Initialize `self`
    ///
    /// - Parameter type: `MutexType` to to create.  Default is .normal
    ///
    /// - Seealso: `MutexType`
    ///
    /// - Note: Care must be taken to ensure matching (lock | tryLock)/unlock pairs, otherwise undefined behaviour can occur.
    ///
    public init(_ type: MutexType = .normal)  {

        var attributes = pthread_mutexattr_t()
        guard pthread_mutexattr_init(&attributes) == 0 else { fatalError("pthread_mutexattr_init") }
        pthread_mutexattr_settype(&attributes, (type == .normal) ? Int32(PTHREAD_MUTEX_NORMAL) : Int32(PTHREAD_MUTEX_RECURSIVE))

        guard pthread_mutex_init(&mutex, &attributes) == 0 else { fatalError("pthread_mutex_init") }
        pthread_mutexattr_destroy(&attributes)
    }
    deinit {
        pthread_mutex_destroy(&mutex)
    }

    ///
    /// Lock the mutex waiting indefinitely for the lock.
    ///
    public final func lock() {
        pthread_mutex_lock(&mutex)
    }

    ///
    /// Attempt to obtain the lock and return immediately returning `true` if the lock was acquired and `false` otherwise.
    ///
    /// - Note: If mutex is of type `MutexType.recursive` and the mutex is currently owned by the calling thread, the mutex lock count will be incremented.
    ///
    /// - Important: When ever tryLock returns `true`, you must have a matching `unlock` call for the try lock.
    ///
    public final func tryLock() -> Bool {
        return pthread_mutex_trylock(&mutex) == 0
    }

    ///
    /// Unlock the mutex.
    ///
    public final func unlock() {
        pthread_mutex_unlock(&mutex)
    }

    fileprivate var mutex = pthread_mutex_t()
}
