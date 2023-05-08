import SwiftUI

struct ContentView: View {
    @State private var isPresented: Bool = false

    @EnvironmentObject var store: Store<AppState>

    // hold properties of the view
    struct Props {
        let counter: Int
        let onIncrement: () -> Void
        let onDecrement: () -> Void
        let onAdd: (Int) -> Void
    }

    private func map(state: CounterState) -> Props {
        Props(
            counter: state.counter,
            onIncrement: { store.dispatch(action: IncrementAction()) },
            onDecrement: { store.dispatch(action: DecrementAction()) },
            onAdd: { store.dispatch(action: AddAction(value: $0)) }
        )
    }

    var body: some View {

        let props = map(state: store.state.counterState)

        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Counter: \(props.counter)")

            Button("Increment") {
                props.onIncrement()
            }

            Button("Decrement") {
                props.onDecrement()
            }

            Button("Add 100") {
                props.onAdd(100)
            }

            Spacer()

            Button("Add Task") {
                isPresented = true
            }

            Spacer()
        }.sheet(isPresented: $isPresented, content: {
            AddTaskView()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        let store = Store(reducer: counterReducer, state: CounterState())
        return ContentView().environmentObject(store)
    }
}
