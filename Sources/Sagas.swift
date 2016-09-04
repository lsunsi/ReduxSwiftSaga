//
//  Sagas.swift
//  ReduxSwiftSaga
//
//  Created by Lucas Sunsi on 9/4/16.
//
//

import Safe
import ReduxSwift

public class Sagas<State> {
    let channel: Chan<Effect>
    var manager: EffectsManager<State>!

    public init() {
        channel = Chan<Effect>.init()
        manager = nil
    }

    public func middleware(store: Store<State>, yield: Dispatcher) -> Dispatcher {
        manager = EffectsManager<State>.init(store: store, channel: channel)
        return {action in
            let action = yield(action)
            self.manager.dispatched(action)
            return action
        }
    }

    public func run(saga: Saga) {
        saga.channel = channel
        dispatch(saga.start)
    }

    public func start() {
        dispatch(manager.start)
    }
}
