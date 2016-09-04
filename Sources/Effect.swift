//
//  Effect.swift
//  ReduxSwiftSaga
//
//  Created by Lucas Sunsi on 9/3/16.
//
//

import Safe
import ReduxSwift

public enum Either<R, L> {
    case Right(R)
    case Left(L)
}

public protocol Effect: class {
    func start()
}

public protocol DispatcherEffect: Effect {
    var dispatch: Dispatcher! {get set}
}

public protocol ListenerEffect: Effect {
    var listening: Bool {get}
    func dispatched(action: ActionType)
}

public protocol SelectorEffect: Effect {
    var state: (() -> Any)! {get set}
}
