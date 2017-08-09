# RunloopQueue

`RunLoopQueue` is a class for running code on a background thread. It works a *bit* like Grand Central Dispatch, but is instead powered by the magic of run loops! 

`RunLoopQueue` works on both macOS and iOS.

```swift
queue = RunloopQueue(named: "My Cool Queue")

queue.async {
    // This code is running on a background thread.
    performAReallyLongOperation()
}
```

### Usage

To use `RunLoopQueue`, copy the `RunLoopQueue.swift` file to your project. You can also add `RunloopQueue+Streams.swift` and `RunloopQueue+URLConnection.swift` if you'd like the `Stream` and `URLConnection` helpers.

### Real-World Applications

`RunLoopQueue` is currently being used in our Cascable family of apps, most notably in `CascableCore`, our SDK for working with WiFi-enabled cameras. `CascableCore` uses `RunLoopQueue` for managing connections with the cameras it supports, and scheduling messages back and forth. You can find out more about `CascableCore` in our [CascableCore Demo App](https://github.com/Cascable/cascablecore-demo).

### RunloopQueue vs. Grand Central Dispatch

`RunLoopQueue` is *not* designed to be a replacement for Grand Central Dispatch. In fact, if you're performing the common flow of starting on the main thread, performing some background work then calling back to the main thread at the end of the operation to update UI, you'll need Grand Central Dispatch to get back to the main thread.

```swift
queue.async {
    // This code is running on a background thread.
    performAReallyLongOperation()
    DispatchQueue.main.async {
        // This code is running on the main thread.
        performUIUpdates()
    }
}
```

However, `RunLoopQueue` does offer some advantages over Grand Central Dispatch in certain circumstances:

#### Thread Consistency

`RunLoopQueue` guarantees that all operations on a given `RunLoopQueue` instance will be executed on the same thread, whether they're performed synchronously or asynchronously. This can be handy if you're interacting with a library that expects thread consistency.

#### Support For "Where Am I?" Checking

`RunLoopQueue` provides the `isRunningOnQueue()` method for checking whether or not the code calling that method is running on the given `RunLoopQueue` instance's thread. 

#### Safe(er) Synchronous Operations

Grand Central Dispatch is *very* unsafe when it comes to synchronous operations, and it's very easy to deadlock your code. Personally, it's so unsafe that I ban its use in any project that I have that sort of influence over. 

`RunLoopQueue`, however, is much better in this regard. Thanks to the `isRunningOnQueue()` method, it can avoid deadlocks when synchronous operations start other synchronous operations:

```swift
queue.sync {
    queue.sync {
        print("Inner sync")
    }
    print("Outer sync")
}
```

Please note that as in *any* multithreaded environment, synchronous operations are prone to deadlocking if you're not careful. 

#### Friendly to Streams and URL Connections

If you're working with streams or `URLConnection` objects, `RunLoopQueue` provides convenience methods for enqueuing such objects on its background thread. This is great if you'd like to process your incoming data in the background:

```swift
let input: InputStream = …
let output: OutputStream = …

input.delegate = self
output.delegate = self

// Scheduling the streams on a RunLoopQueue will cause their 
// delegate methods to be called on a background thread.
queue.schedule(input)
queue.schedule(output)

input.open()
output.open()
```

### Objective-C

`RunLoopQueue` is written in Swift 3, but is fully compatible with Objective-C.

```objc
self.runloopQueue = [[CBLRunloopQueue alloc] initWithName:@"My Cool Queue"];
[self.runloopQueue async:^{
    [self performAReallyLongOperation];
}];

[self.runloopQueue scheduleStream:self.inputStream];
```

### License

For more information, see the [LICENSE.md](LICENSE.md) file.

