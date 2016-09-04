//: Playground - noun: a place where people can play

import ReduxSwiftSaga

class S: Saga {
    override func start() {
        yield(Call<Int, Int> {done in
            done(Either<Int,Int>.Right(1))
        })
    }
}

let sagas = Sagas<Int>.init()

sagas.middleware

sagas.run(S())

//sagas.start()