import SwiftUI
import CoreLittleManComputer

struct CodePane: View {
    @Environment(EditorState.self) private var state
    @FocusState private var isEditing: Bool

    var body: some View {
        @Bindable var state = state

        VStack(spacing: 0) {
            TextEditor(text: $state.source)
                .font(.system(.body, design: .monospaced))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.asciiCapable)
                .focused($isEditing)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
                .padding([.horizontal, .top])
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { isEditing = false }
                    }
                }

            if !state.diagnostics.isEmpty {
                DiagnosticsList(diagnostics: state.diagnostics)
                    .padding([.horizontal, .top])
            }

            AssemblyStatus()
                .padding()
        }
    }
}

/// Every problem the assembler found, one per row.
struct DiagnosticsList: View {
    let diagnostics: [AssemblyDiagnostic]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("\(diagnostics.count) problem\(diagnostics.count == 1 ? "" : "s")", systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundStyle(.red)

            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(diagnostics, id: \.self) { diagnostic in
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("Line \(diagnostic.line)")
                                .font(.system(.caption, design: .monospaced, weight: .semibold))
                                .foregroundStyle(.secondary)
                            Text(diagnostic.message)
                                .font(.callout)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: 140)
        }
        .panel()
    }
}

/// One line saying whether the editor text matches what is loaded.
struct AssemblyStatus: View {
    @Environment(EditorState.self) private var state

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .foregroundStyle(tint)
            Text(text)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    private var text: String {
        if !state.diagnostics.isEmpty {
            "Fix the problems above, then assemble again."
        } else if let program = state.program, !state.needsAssembly {
            "Assembled into \(program.length) mailbox\(program.length == 1 ? "" : "es")."
        } else if state.isAssembled {
            "Edited since the last assemble."
        } else {
            "Write a program, then tap Assemble."
        }
    }

    private var symbol: String {
        if !state.diagnostics.isEmpty {
            "xmark.circle.fill"
        } else if state.isAssembled, !state.needsAssembly {
            "checkmark.circle.fill"
        } else {
            "pencil.circle"
        }
    }

    private var tint: Color {
        if !state.diagnostics.isEmpty {
            .red
        } else if state.isAssembled, !state.needsAssembly {
            .green
        } else {
            .secondary
        }
    }
}

#Preview(traits: .sampleData) {
    let appState = AppState()
    CodePane()
        .environment(appState)
        .environment(appState.editorState)
}
