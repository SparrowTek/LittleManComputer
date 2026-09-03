import SwiftUI
@preconcurrency import SwiftData
import CoreLittleManComputer

/// Saved programs and the built-in samples.
struct LibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(EditorState.self) private var state
    @Query(sort: \SavedProgram.modifiedAt, order: .reverse) private var programs: [SavedProgram]
    @State private var isNaming = false
    @State private var newName = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Your Programs") {
                    if programs.isEmpty {
                        Text("Tap Save to keep the program in the editor.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(programs) { program in
                        Button {
                            load(program.source)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(program.name)
                                    .foregroundStyle(.primary)
                                Text(program.modifiedAt, format: .dateTime.day().month().year().hour().minute())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }

                Section("Samples") {
                    ForEach(SamplePrograms.all) { sample in
                        Button {
                            load(sample.source)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(sample.title)
                                    .foregroundStyle(.primary)
                                Text(sample.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Programs")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Save", systemImage: "square.and.arrow.down") {
                        isNaming = true
                    }
                }
            }
            .alert("Save Program", isPresented: $isNaming) {
                TextField("Name", text: $newName)
                Button("Save", action: save)
                Button("Cancel", role: .cancel) {
                    newName = ""
                }
            } message: {
                Text("Give the program in the editor a name.")
            }
        }
    }

    private func load(_ source: String) {
        state.load(source)
        dismiss()
    }

    private func save() {
        defer { newName = "" }
        let name = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        modelContext.insert(SavedProgram(name: name, source: state.source))
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(programs[index])
        }
    }
}

#Preview(traits: .sampleData) {
    let appState = AppState()
    LibraryView()
        .environment(appState)
        .environment(appState.editorState)
}
