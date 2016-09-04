//
//  Manager.swift
//  ReduxSwiftSaga
//
//  Created by Lucas Sunsi on 9/4/16.
//
//

import Safe
import ReduxSwift

class EffectsManager<State> {
    let channel: Chan<Effect>
    var listeners: [ListenerEffect]
    let store: Store<State>

    init(store: Store<State>, channel: Chan<Effect>) {
        self.channel = channel
        self.listeners = []
        self.store = store
    }

    func dispatched(action: ActionType) {
        listeners = listeners.filter {e in
            e.dispatched(action)
            return e.listening
        }
    }

    func start() {
        while let e = <-channel {
            if let de = e as? DispatcherEffect {
                de.dispatch = store.dispatch
            }

            if let le = e as? ListenerEffect {
                if le.listening {
                    listeners.append(le)
                }
            }

            if let se = e as? SelectorEffect {
                se.state = {self.store.state}
            }

            e.start()
        }
    }
}
