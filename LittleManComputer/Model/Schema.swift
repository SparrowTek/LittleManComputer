import SwiftUI
@preconcurrency import SwiftData

typealias LMCSchema = LMCSchemaV1

nonisolated enum LMCSchemaV1: VersionedSchema, Sendable {
    static let versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [
            SavedProgram.self,
        ]
    }
}

struct LMCDataContainerViewModifier: ViewModifier {
    let container: ModelContainer
    let schema = Schema(LMCSchema.models)

    init(inMemory: Bool) {
        do {
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
            container = try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }

    func body(content: Content) -> some View {
        content
            .modelContainer(container)
    }
}

enum LMCModelOptions {
    static let inMemoryPersistence = false
}

extension View {
    func setupModel(inMemory: Bool = LMCModelOptions.inMemoryPersistence) -> some View {
        modifier(LMCDataContainerViewModifier(inMemory: inMemory))
    }
}
