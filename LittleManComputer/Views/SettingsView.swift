import SwiftUI
import CoreLittleManComputer

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(EditorState.self) private var state

    var body: some View {
        @Bindable var state = state

        NavigationStack {
            Form {
                Section {
                    Picker("Speed", selection: $state.speedSetting) {
                        ForEach(EditorState.SpeedSetting.allCases) { setting in
                            Text(setting.title).tag(setting)
                        }
                    }
                    Picker("Overflow", selection: overflowSelection) {
                        Text("Stop with an error").tag(OverflowBehavior.fault)
                        Text("Wrap around").tag(OverflowBehavior.wrap)
                    }
                } header: {
                    Text("Execution")
                } footer: {
                    Text("Overflow decides what happens when ADD or SUB leaves the accumulator's range of -999 to 999. Wrapping keeps the sign and the low three digits.")
                }

                Section("About") {
                    LabeledContent("Version", value: version)
                    if let url = URL(string: "https://en.wikipedia.org/wiki/Little_Man_Computer") {
                        Link(destination: url) {
                            Label("Little Man Computer on Wikipedia", systemImage: "book")
                        }
                    }
                    HStack {
                        Spacer()
                        Image("sparrowtek")
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var overflowSelection: Binding<OverflowBehavior> {
        Binding(
            get: { state.overflowBehavior },
            set: { state.setOverflowBehavior($0) }
        )
    }

    private var version: String {
        let short = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "—"
        return "\(short) (\(build))"
    }
}

#Preview(traits: .sampleData) {
    let appState = AppState()
    SettingsView()
        .environment(appState)
        .environment(appState.editorState)
}
