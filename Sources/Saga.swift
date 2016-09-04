//
//  Saga.swift
//  ReduxSwiftSaga
//
//  Created by Lucas Sunsi on 9/3/16.
//
//

import Safe

public protocol Yieldable: class {
    var resume: (() -> ())! {get set}
}

public class Saga {
    public let mutex: Mutex
    public var channel: Chan<Effect>!

    public init() {
        mutex = Mutex.init()
        channel = nil
    }

    public func yield
        <T where T: Yieldable, T: Effect>
        (effect: T) -> T {
        effect.resume = mutex.unlock

        self.mutex.lock {
            self.channel <- effect
            self.mutex.lock()
        }

        return effect
    }

    public func start() {}
}
