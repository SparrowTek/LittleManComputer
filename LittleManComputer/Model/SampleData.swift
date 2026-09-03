import SwiftUI
@preconcurrency import SwiftData
import CoreLittleManComputer

/// Seeds an in-memory container with the sample programs for previews.
struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let container = try ModelContainer(
            for: SavedProgram.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        for sample in SamplePrograms.all {
            container.mainContext.insert(SavedProgram(name: sample.title, source: sample.source))
        }
        try container.mainContext.save()
        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
