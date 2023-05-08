import Foundation

struct State {
    var counter: Int = 0
}

protocol Action { }

struct IncrementAction: Action { }
struct DecrementAction: Action { }
struct AddAction: Action {
    let value: Int
}

func reduce(state: State, action: Action) -> State {
    var state = state

    switch action {
    case _ as IncrementAction:
        state.counter += 1
    case _ as DecrementAction:
        state.counter -= 1
    case let action as AddAction:
        state.counter += action.value
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
