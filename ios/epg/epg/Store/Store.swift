import Foundation

struct State {

}

protocol Action {

}

func reduce(state: State, action: Action) -> State {
    return state
}

typealias Reducer = (_ state: State, _ action: Action) -> State

class Store: ObservableObject {
    private var reducer: Reducer

    @Published var state: State

    init(reducer: @escaping Reducer, state: State) {
        self.reducer = reducer
        self.state = state
    }

    func dispatch(action: Action) {
        state = reduce(state: state, action: action)
    }
}
