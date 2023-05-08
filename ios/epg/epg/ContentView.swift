import SwiftUI

struct ContentView: View {

    @EnvironmentObject var store: Store

    // hold properties of the view
    struct Props {
        let counter: Int
        let onIncrement: () -> Void
    }

    private func map(state: State) -> Props {
        Props(counter: state.counter) {
            store.dispatch(action: IncrementAction())
        }
    }

    var body: some View {

        let props = map(state: store.state)

        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Counter: \(props.counter)")

            Button("Increment") {
                props.onIncrement()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
