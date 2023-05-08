import Foundation

struct State {
    var counter: Int = 0
}

protocol Action { }

struct IncrementAction: Action { }

func reduce(state: State, action: Action) -> State {
    var state = state

    switch action {
    case _ as IncrementAction:
        state.counter += 1
    default:
        break
    }

    return state
}

typealias Reducer = (_ state: State, _ action: Action) -> State

class Store: ObservableObject {
    private var reducer: Reducer

    @Published var state: State

    init(reducer: @escaping Reducer, state: State = State()) {
        self.reducer = reducer
        self.state = state
    }

    func dispatch(action: Action) {
        state = reduce(state: state, action: action)
    }
}
