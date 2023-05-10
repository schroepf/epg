import SwiftUI

struct TVSettingsView: View {
    let onLoadContentFromDb: () -> Void
    let onImportLocalXml: () -> Void
    let onImportRemoteXml: () -> Void
    let onExit: () -> Void

    enum Setting: Hashable {
        case updateUiFromDb
        case importLocalXml
        case importRemoteXml
    }

    @FocusState private var focusedSetting: Setting?

    var body: some View {

        HStack {
            Spacer()

            VStack {
                VStack {
                    Text("Settings")
                    List {
                        Button("Load from DB") {
                            onLoadContentFromDb()
                        }
                        .focused($focusedSetting, equals: .updateUiFromDb)

                        Button("Fetch from Local XML") {
                            onImportLocalXml()
                        }
                        .focused($focusedSetting, equals: .importLocalXml)

                        Button("Fetch from Remote XML") {
                            onImportRemoteXml()
                        }
                        .focused($focusedSetting, equals: .importRemoteXml)
                    }
                    .padding([.leading, .trailing])
                    .frame(maxWidth: 600)
                    .listStyle(.grouped)
                    .task {
                        focusedSetting = .updateUiFromDb
                    }
                }

                Spacer()
            }
            .background(.ultraThinMaterial)
        }
        .focusSection()
        .onExitCommand {
            // when "MENU" button is pressed
            onExit()
        }
    }
}
