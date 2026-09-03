import SwiftUI
import CoreLittleManComputer

struct EditorPresenter: View {
    @Environment(AppState.self) private var appState
    @Environment(EditorState.self) private var state
    @State private var mailboxDraft = ""

    var body: some View {
        @Bindable var state = state

        NavigationStack {
            EditorView()
                .navigationTitle("Little Man Computer")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Programs", systemImage: "folder") {
                            appState.sheet = .library
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button("Help", systemImage: "questionmark.circle") {
                            appState.sheet = .help
                        }
                        Button("Settings", systemImage: "gearshape") {
                            appState.sheet = .settings
                        }
                    }
                    EditorControls(state: state)
                }
        }
        .task { await state.machine.observe() }
        .task($state.runTrigger) { await state.runProgram() }
        .task($state.commandTrigger) { command in await state.perform(command) }
        .alert(
            "Edit Mailbox",
            isPresented: Binding(
                get: { state.editingAddress != nil },
                set: { if !$0 { state.editingAddress = nil } }
            ),
            presenting: state.editingAddress
        ) { address in
            TextField("000", text: $mailboxDraft)
                .keyboardType(.numberPad)
            Button("Save") { saveMailbox(at: address) }
            Button("Cancel", role: .cancel) { mailboxDraft = "" }
        } message: { address in
            Text("Mailbox \(address.description) holds \(state.machine.machine.memory[address].description). Enter a value from 000 to 999.")
        }
    }

    private func saveMailbox(at address: MailboxAddress) {
        defer { mailboxDraft = "" }
        guard let word = Word(mailboxDraft) else { return }
        state.write(word, at: address)
    }
}

#Preview(traits: .sampleData) {
    let appState = AppState()
    EditorPresenter()
        .environment(appState)
        .environment(appState.editorState)
}
