//
//  Base.swift
//  ReduxSwiftSaga
//
//  Created by Lucas Sunsi on 9/4/16.
//
//

import ReduxSwift
@testable import ReduxSwiftSaga

struct State {
    var name: String? = nil
    var fetching: Bool = false
    var error: String? = nil
}

struct UserFetchRequested: ActionType {
    let identifier: String
}
struct UserFetchSucceeded: ActionType {
    let name: String
}
struct UserFetchFailed: ActionType {
    let error: String
}

func reducer(action: ActionType, state: State?) -> State {
    var state = state ?? State.init()

    switch action {

    case _ as UserFetchRequested:
        state.fetching = true

    case let a as UserFetchSucceeded:
        state.fetching = false
        state.name = a.name

    case let a as UserFetchFailed:
        state.fetching = false
        state.error = a.error

    default: break
    }

    return state
}

class FetchUser: Saga {
    static let success = "Right!"
    static let error = ":("

    let shouldFail: Bool

    init(shouldFail: Bool) {
        self.shouldFail = shouldFail
    }

    typealias EitherSS = Either<String, String>

    override func start() {
        while true {
            _ = yield(Take<UserFetchRequested>())

            let call = yield(Call<String, String> {done in
                if self.shouldFail {
                    done(EitherSS.Left(FetchUser.error))
                } else {
                    done(EitherSS.Right(FetchUser.success))
                }
            })

            if case .Right(let res) = call.result! {
                yield(Put(UserFetchSucceeded(name: res)))
            } else {
                yield(Put(UserFetchFailed(error: ":(")))
            }
        }
    }
}
