import Foundation

typealias Dispatcher = (Action) -> Void

typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State
typealias Middleware<StoreState: ReduxState> = (StoreState, Action, @escaping Dispatcher) -> Void

// MARK: - States

protocol ReduxState { }

struct AppState: ReduxState {
    var epgState = EpgState()
}

struct EpgState: ReduxState {
    var epg: Epg? = nil
}

// MARK: - Actions

protocol Action { }

struct LoadEpgDataFromLocalXmlAsync: Action { }

struct LoadEpgDataFromRemoteXmlAsync: Action {
    let url: String
}

struct SetEpgData: Action {
    let epg: Epg?
}

// MARK: - Store

class Store<StoreState: ReduxState>: ObservableObject {
    private let reducer: Reducer<StoreState>
    private let middlewares: [Middleware<StoreState>]

    @Published var state: StoreState

    init(
        reducer: @escaping Reducer<StoreState>,
        state: StoreState,
        middlewares: [Middleware<StoreState>] = []
    ) {
        self.reducer = reducer
        self.state = state
        self.middlewares = middlewares
    }

    func dispatch(action: Action) {
        DispatchQueue.main.async {
            self.state = self.reducer(self.state, action)
        }

        // run all middlewares
        middlewares.forEach { middleware in
            middleware(state, action, dispatch)
        }
    }
}
