import SwiftUI
import CoreLittleManComputer

/// Collects one card for the in-basket.
struct InputSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(EditorState.self) private var state
    @State private var text = ""
    @FocusState private var isFocused: Bool

    private var word: Word? {
        Word(text)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "tray.and.arrow.down")
                    .font(.system(size: 44))
                    .foregroundStyle(Color.accentColor)

                Text(state.isAwaitingInput ? "The Little Man is waiting for a card." : "Add a card to the in-basket.")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("Enter a value from 000 to 999.")
                    .foregroundStyle(.secondary)

                TextField("000", text: $text)
                    .keyboardType(.numberPad)
                    .font(.system(.largeTitle, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .focused($isFocused)
                    .onSubmit(submit)
                    .padding(.horizontal, 40)

                Button("Place in In-Basket", action: submit)
                    .buttonStyle(.borderedProminent)
                    .disabled(word == nil)
            }
            .padding()
            .navigationTitle("Input")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .onAppear {
            isFocused = true
        }
    }

    private func submit() {
        guard let word else { return }
        state.provideInput(word)
        dismiss()
    }
}

#Preview(traits: .sampleData) {
    let appState = AppState()
    InputSheet()
        .environment(appState)
        .environment(appState.editorState)
}
