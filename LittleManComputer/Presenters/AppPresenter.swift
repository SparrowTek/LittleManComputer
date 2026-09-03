import SwiftUI

struct AppPresenter: View {
    @Environment(AppState.self) private var state

    var body: some View {
        @Bindable var state = state

        Group {
            switch state.route {
            case .editor:
                EditorPresenter()
                    .environment(state.editorState)
            }
        }
        .sheet(item: $state.sheet) { sheet in
            sheetView(for: sheet)
                .environment(state.editorState)
        }
        .alert(
            state.alert?.title ?? "",
            isPresented: Binding(
                get: { state.alert != nil },
                set: { if !$0 { state.alert = nil } }
            ),
            presenting: state.alert
        ) { _ in
            Button("OK", role: .cancel) {}
        } message: { alert in
            Text(alert.message)
        }
    }

    @ViewBuilder
    private func sheetView(for sheet: AppState.Sheet) -> some View {
        switch sheet {
        case .help:
            HelpView()
        case .library:
            LibraryView()
        case .settings:
            SettingsView()
        case .input:
            InputSheet()
        }
    }
}

#Preview(traits: .sampleData) {
    AppPresenter()
        .environment(AppState())
}
