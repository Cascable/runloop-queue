//
//  RunloopQueueTests.swift
//  RunloopQueueTests
//
//  Created by Daniel Kennett on 2017-02-14.
//  For license information, see LICENSE.md.
//

import XCTest
import RunloopQueue

class RunloopQueueTests: XCTestCase {

    var queue: RunloopQueue!
    
    override func setUp() {
        super.setUp()
        queue = RunloopQueue(named: "Test")
    }
    
    override func tearDown() {
        queue = nil
        super.tearDown()
    }
    
    func testSync() {
        var workCompleted = false

        XCTAssertFalse(queue.isRunningOnQueue())

        queue.sync {
            XCTAssert(self.queue.isRunningOnQueue())
            workCompleted = true
        }

        XCTAssertFalse(queue.isRunningOnQueue())
        XCTAssert(workCompleted)
    }

    func testInnerSync() {
        var outerWorkCompleted = false
        var innerWorkCompleted = false

        XCTAssertFalse(queue.isRunningOnQueue())

        queue.sync {
            XCTAssert(self.queue.isRunningOnQueue())
            outerWorkCompleted = true

            self.queue.sync {
                XCTAssert(self.queue.isRunningOnQueue())
                innerWorkCompleted = true
            }
        }

        XCTAssertFalse(queue.isRunningOnQueue())
        XCTAssert(outerWorkCompleted)
        XCTAssert(innerWorkCompleted)
    }

    func testSerialSync() {
        var firstWorkCompleted = false
        var secondWorkCompleted = false

        XCTAssertFalse(queue.isRunningOnQueue())

        queue.sync {
            XCTAssert(self.queue.isRunningOnQueue())
            firstWorkCompleted = true
        }

        XCTAssert(firstWorkCompleted)
        XCTAssertFalse(secondWorkCompleted)

        queue.sync {
            XCTAssert(self.queue.isRunningOnQueue())
            secondWorkCompleted = true
        }

        XCTAssertFalse(queue.isRunningOnQueue())
        XCTAssert(firstWorkCompleted)
        XCTAssert(secondWorkCompleted)
    }

    func testAsync() {
        var workCompleted = false
        let workDone = self.expectation(description: "Work done")

        XCTAssertFalse(queue.isRunningOnQueue())

        queue.async {
            XCTAssert(self.queue.isRunningOnQueue())
            workCompleted = true
            workDone.fulfill()
        }

        waitForExpectations(timeout: 2.0, handler: nil)
        XCTAssertFalse(queue.isRunningOnQueue())
        XCTAssert(workCompleted)
    }

    func testSerialAsync() {
        var firstWorkCompleted = false
        var secondWorkCompleted = false
        let firstWorkDone = self.expectation(description: "First work done")
        let secondWorkDone = self.expectation(description: "Second work done")

        XCTAssertFalse(queue.isRunningOnQueue())

        queue.async {
            XCTAssertFalse(secondWorkCompleted)
            Thread.sleep(forTimeInterval: 1.0)
            XCTAssert(self.queue.isRunningOnQueue())
            firstWorkCompleted = true
            firstWorkDone.fulfill()
        }

        queue.async {
            XCTAssert(firstWorkCompleted)
            Thread.sleep(forTimeInterval: 1.0)
            XCTAssert(self.queue.isRunningOnQueue())
            secondWorkCompleted = true
            secondWorkDone.fulfill()
        }

        XCTAssertFalse(firstWorkCompleted)
        XCTAssertFalse(secondWorkCompleted)

        waitForExpectations(timeout: 3.0, handler: nil)
        XCTAssertFalse(queue.isRunningOnQueue())
        XCTAssert(firstWorkCompleted)
        XCTAssert(secondWorkCompleted)
    }
    
}
