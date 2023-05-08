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
        let onIncrementAsync: () -> Void
        let onLoadEpgXml: () -> Void
    }

    private func map(state: CounterState) -> Props {
        Props(
            counter: state.counter,
            onIncrement: { store.dispatch(action: IncrementAction()) },
            onDecrement: { store.dispatch(action: DecrementAction()) },
            onAdd: { store.dispatch(action: AddAction(value: $0)) },
            onIncrementAsync: { store.dispatch(action: IncrementActionAsync()) },
            onLoadEpgXml: { store.dispatch(action: LoadEpgDataFromXmlAsync() ) }
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

            Button("Increment Async") {
                props.onIncrementAsync()
            }

            Button("Decrement") {
                props.onDecrement()
            }

            Button("Add 100") {
                props.onAdd(100)
            }

            Button("Load XML") {
                props.onLoadEpgXml()
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
