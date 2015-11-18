/**
 *   TLWriter.h
 *
 *   Copyright 2015 Tony Stone
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
 *   Created by Tony Stone on 11/12/15.
 */
#import <Foundation/Foundation.h>
#import "TLLogLevel.h"

@protocol TLWriter <NSObject>

@required
    - (void) log: (NSTimeInterval) timestamp level: (LogLevel) level tag: (nonnull const NSString *) tag message: (nullable const NSString *) message file: (nonnull const NSString *) file function: (nonnull const NSString *) function lineNumber: (NSUInteger) lineNumber;

@end