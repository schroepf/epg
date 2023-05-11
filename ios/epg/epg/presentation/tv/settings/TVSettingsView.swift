import SwiftUI

struct TVSettingsView: View {
    @State var settingsVisible: Bool = false

    let onLoadContentFromDb: () -> Void
    let onImportLocalXml: () -> Void
    let onImportRemoteXml: () -> Void

    enum Setting: Hashable {
        case updateUiFromDb
        case importLocalXml
        case importRemoteXml
    }

    @FocusState private var focusedSetting: Setting?

    var body: some View {

        HStack {
            Spacer()

            ZStack(alignment: .topTrailing) {

                VStack {
                        Button {
                            settingsVisible.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                        }
                        .clipShape(Circle())

                    Spacer()
                }

                if (settingsVisible) {
                    VStack {
                            Text("Settings")
                            List {
                                Button("Load from DB") {
                                    onLoadContentFromDb()
                                    settingsVisible = false
                                }
                                .focused($focusedSetting, equals: .updateUiFromDb)

                                Button("Fetch from Local XML") {
                                    onImportLocalXml()
                                    settingsVisible = false
                                }
                                .focused($focusedSetting, equals: .importLocalXml)

                                Button("Fetch from Remote XML") {
                                    onImportRemoteXml()
                                    settingsVisible = false
                                }
                                .focused($focusedSetting, equals: .importRemoteXml)
                            }
                            .padding([.leading, .trailing])
                            .frame(maxWidth: 600)
                            .listStyle(.grouped)
                            .task {
                                focusedSetting = .updateUiFromDb
                            }

                        Spacer()
                    }
                    .background(.ultraThinMaterial)
                    .focusSection()
                    .onExitCommand {
                        // when "MENU" button is pressed
                        settingsVisible = false
                    }
                }
            }
        }
    }
}
