import Foundation

typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State

// MARK: - States

protocol ReduxState { }

struct AppState: ReduxState {
    var counterState = CounterState()
    var taskState = TaskState()
}

struct TaskState: ReduxState {
    var tasks: [Task] = .init()
}

struct CounterState: ReduxState {
    var counter: Int = 0
}


// MARK: - Actions

protocol Action { }

struct IncrementAction: Action { }
struct DecrementAction: Action { }
struct AddTaskAction: Action {
    let task: Task
}

struct AddAction: Action {
    let value: Int
}

// MARK: - Store

class Store<StoreState: ReduxState>: ObservableObject {
    private var reducer: Reducer<StoreState>
    @Published var state: StoreState

    init(reducer: @escaping Reducer<StoreState>, state: StoreState) {
        self.reducer = reducer
        self.state = state
    }

    func dispatch(action: Action) {
        state = reducer(state, action)
    }
}
