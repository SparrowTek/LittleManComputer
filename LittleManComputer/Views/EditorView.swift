import SwiftUI
import CoreLittleManComputer

struct EditorView: View {
    @Environment(EditorState.self) private var state
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        @Bindable var state = state

        Group {
            if horizontalSizeClass == .regular {
                HStack(spacing: 0) {
                    CodePane()
                        .frame(minWidth: 320, idealWidth: 420, maxWidth: 520)
                    Divider()
                    MachinePane()
                }
            } else {
                VStack(spacing: 0) {
                    Picker("Pane", selection: $state.pane) {
                        ForEach(EditorState.Pane.allCases) { pane in
                            Text(pane.title).tag(pane)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                    switch state.pane {
                    case .code:
                        CodePane()
                    case .machine:
                        MachinePane()
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

/// The bottom bar: assemble, step, run or pause, reset, and speed.
struct EditorControls: ToolbarContent {
    let state: EditorState

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button("Assemble", systemImage: "hammer") {
                state.assemble()
            }
            .tint(state.needsAssembly ? Color.accentColor : nil)

            Spacer()

            Button("Step", systemImage: "forward.frame") {
                state.step()
            }
            .disabled(!state.canStep)

            Spacer()

            if state.machine.isRunning {
                Button("Pause", systemImage: "pause.fill") {
                    state.pause()
                }
            } else {
                Button("Run", systemImage: "play.fill") {
                    state.run()
                }
                .disabled(!state.canRun)
            }

            Spacer()

            Button("Reset", systemImage: "arrow.counterclockwise") {
                state.reset()
            }
            .disabled(!state.isAssembled)

            Spacer()

            Menu("Speed", systemImage: "gauge.with.needle") {
                Picker("Speed", selection: speedSelection) {
                    ForEach(EditorState.SpeedSetting.allCases) { setting in
                        Text(setting.title).tag(setting)
                    }
                }
            }
        }
    }

    private var speedSelection: Binding<EditorState.SpeedSetting> {
        Binding(
            get: { state.speedSetting },
            set: { state.speedSetting = $0 }
        )
    }
}

/// The rounded panel every machine section sits in.
struct PanelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func panel() -> some View {
        modifier(PanelStyle())
    }
}

#Preview(traits: .sampleData) {
    let appState = AppState()
    NavigationStack {
        EditorView()
    }
    .environment(appState)
    .environment(appState.editorState)
}
