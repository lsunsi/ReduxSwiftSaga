//
//  Effects.swift
//  ReduxSwiftSaga
//
//  Created by Lucas Sunsi on 9/4/16.
//
//

import ReduxSwift

public class Put: Effect, DispatcherEffect, Yieldable {
    public var dispatch: Dispatcher!
    public var resume: (() -> ())!
    let action: ActionType

    public init(_ action: ActionType) {
        self.action = action
    }

    public func start() {
        dispatch(action)
        resume()
    }
}

public class Take<Action: ActionType>: Effect, ListenerEffect, Yieldable {
    public var resume: (() -> ())!
    public var action: Action!

    public init() {
        resume = nil
        action = nil
    }

    public var listening: Bool {
        return action == nil
    }

    public func dispatched(action: ActionType) {
        if let action = action as? Action {
            self.action = action
            resume()
        }
    }

    public func start() {}
}

public class Select<State, Target>: Effect, SelectorEffect, Yieldable {
    public typealias Mapper = State -> Target

    public var resume: (() -> ())!
    public var state: (() -> Any)!
    public var selection: Target!
    let mapper: Mapper

    public init(_ mapper: Mapper) {
        self.mapper = mapper
    }

    public func start() {
        if let state = state() as? State {
            selection = mapper(state)
        }
    }
}

public class Call<Success, Error>: Effect, Yieldable {
    public typealias Result = Either<Success, Error>
    public typealias Promise = (Result -> ()) -> ()

    public var resume: (() -> ())!
    let promise: Promise
    public var result: Result?

    public init(_ promise: Promise) {
        self.promise = promise
    }

    public func start() {
        promise {result in
            self.result = result
            self.resume()
        }
    }
}
