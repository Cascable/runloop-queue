//
//  RunloopQueue+Streams.swift
//  RunloopQueue
//
//  Created by Daniel Kennett on 2017-02-14.
//  For license information, see LICENSE.md.
//

import Foundation

public extension RunloopQueue {

    /// Schedules the given NSURLConnection into the queue.
    ///
    /// - Parameter connection: The connection to schedule.
    @objc(scheduleConnection:)
    func schedule(_ connection: NSURLConnection) {
        sync {
            connection.schedule(in: RunLoop.current, forMode: RunLoop.Mode.common)
        }
    }

    /// Removes the given NSURLConnection from the queue.
    ///
    /// - Parameter connection: The connection to remove.
    @objc(unscheduleConnection:)
    func unschedule(_ connection: NSURLConnection) {
        sync {
            connection.unschedule(from: RunLoop.current, forMode: RunLoop.Mode.common)
        }
    }

}
