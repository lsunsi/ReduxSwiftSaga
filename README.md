# ReduxSwiftSaga

ReduxSwiftSaga is a side effect model for [ReduxSwift](https://github.com/lsunsi/ReduxSwift) apps.
It is heavily inspired by [redux-saga](https://github.com/yelouafi/redux-saga) and tries to be for ReduxSwift what redux-saga is for  [Redux](https://github.com/reactjs/redux).

[![Swift version](https://img.shields.io/badge/Swift-2.2-brightgreen.svg?style=flat-square)](https://swift.org/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20macOS-lightgrey.svg?style=flat-square)](https://swift.org/)
[![Release](https://img.shields.io/badge/Release-0.1.0-blue.svg?style=flat-square)](https://github.com/lsunsi/ReduxSwiftSaga/releases)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](https://github.com/lsunsi/ReduxSwiftSaga/blob/master/LICENSE)

*This framework is probably not suited for production and is intended as a proof of concept.*

###### Functionality
- Asynchronous Flow
- Generator-like Syntax
- Declarative Side Effects

###### Implementation
- Type Safe
- Concurrent and **Parallel**
- Experimental!

## Getting Started

> "The mental model is that a saga is like a separate thread in your application that's solely responsible for side effects."
> redux-sagas's documentation

### Effects
An effect is an instance that describes an action without actually running it.
Effects are meant to be run by the middleware when a saga tells it so.
This framework includes 4 types of basic effects: Put, Take, Select and Call.
Let's get to know them better.

#### Put
This effect takes a redux action as his single parameter.
When ran, it dispatches it to the Store.

```swift
_ = Put.init(SOME_ACTION())
```

#### Take
This effect is generic and depends on a redux action type.
When ran, it waits for an action with such type to be dispatched and saves it.

```swift
let t = Take<WAITED_ACION>()
t.action // action instance saved
```

#### Select
This effect takes a mapper function of generic types.
When ran, it maps the Store state through the mapper and stores the result.

```swift
let s = Select<State, Int> {$0.someCounter}
s.selection // result as an Int
```

#### Call
This effect takes a promise-style function that should call it's first argument with Either a result or an error.
The result and error types are generic.

```swift
let c = Call<String, String> {done
  if problem {
    done(Either<String,String>.Left("problem :("))
  } else {
    done(Either<String,String>.Right("no problem :)"))
  }
}
c.result // Either
```

### Saga
A Saga represents a single side-effects generator that runs concurrently with your application.
It's only function is to tell which side-effect to run next.

This framework provides a Saga class that is meant to be overridden.
The start method is where all your logic should go.
The yield method is how you tell you want some effect to be run.
When ran, it blocks the saga until the effect is done running.

This saga waits for an action of type UserFetchRequested to be dispatched to the Store.
Then is calls some function to fetch the users data.
At last, it dispatches a UserFetchSucceeded or a UserFetchFailed action to the Store depending on the call result.
```swift
class FetchUser: Saga {
    typealias E = Either<User, String>

    override func start() {
          let take = yield(Take<UserFetchRequested>())

          let call = yield(Call<User, String>{done in
            if let user = fetch(take.action.id) {
              done(E.Right(user))
            } else {
              done(E.Left("sorry :("))
            }
          })

          switch call.result! {
            case .Right(let user):
              yield(Put(UserFetchSucceeded(user: user)))
            case .Left(let error):
              yield(Put(UserFetchFailed(error: error)))
            default: break
          }
    }
}
```

### Fire it up
```swift
let sagas = Sagas<State>.init()
let store = Store<State>.init(reducer: reducer, state: nil, middlewares: [sagas.middleware])

sagas.run(FetchUser.init()) // runs your saga in another thread
sagas.start() // start running effects from all your sagas
```

## Installation

### Carthage

```
github "lsunsi/ReduxSwiftSaga"
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
