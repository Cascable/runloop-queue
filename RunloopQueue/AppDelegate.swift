//
//  AppDelegate.swift
//  RunloopQueue
//
//  Created by Daniel Kennett on 2017-02-14.
//  Copyright © 2017 Cascable AB. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    var queue: RunloopQueue!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        queue = RunloopQueue(named: "Test")

        queue.sync {
            print("Sync!")
        }

        queue.async {
            print("Async!")

        }

        print("Done")
        queue = nil

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

