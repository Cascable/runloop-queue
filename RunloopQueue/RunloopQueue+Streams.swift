//
//  RunloopQueue+Streams.swift
//  RunloopQueue
//
//  Created by Daniel Kennett on 2017-02-14.
//  For license information, see LICENSE.md.
//

import Foundation

public extension RunloopQueue {

    /// Schedules the given stream into the queue.
    ///
    /// - Parameter stream: The stream to schedule.
    @objc(scheduleStream:)
    public func schedule(_ stream: Stream) {
        if let input = stream as? InputStream {
            sync { CFReadStreamScheduleWithRunLoop(input as CFReadStream, CFRunLoopGetCurrent(), .commonModes) }
        } else if let output = stream as? OutputStream {
            sync { CFWriteStreamScheduleWithRunLoop(output as CFWriteStream, CFRunLoopGetCurrent(), .commonModes) }
        }
    }

    /// Removes the given stream from the queue.
    ///
    /// - Parameter stream: The stream to remove.
    @objc(unscheduleStream:)
    public func unschedule(_ stream: Stream) {
        if let input = stream as? InputStream {
            sync { CFReadStreamUnscheduleFromRunLoop(input as CFReadStream, CFRunLoopGetCurrent(), .commonModes) }
        } else if let output = stream as? OutputStream {
            sync { CFWriteStreamUnscheduleFromRunLoop(output as CFWriteStream, CFRunLoopGetCurrent(), .commonModes) }
        }
    }

}
