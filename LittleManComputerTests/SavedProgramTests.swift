import Foundation
import Testing
@preconcurrency import SwiftData
import CoreLittleManComputer
@testable import LMC

@MainActor
@Suite("SavedProgram")
struct SavedProgramTests {
    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: SavedProgram.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    @Test func storesAndFetchesPrograms() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let created = Date(timeIntervalSince1970: 1_000)
        context.insert(SavedProgram(name: "Echo", source: SamplePrograms.echo.source, createdAt: created))
        try context.save()

        let programs = try context.fetch(FetchDescriptor<SavedProgram>())
        #expect(programs.count == 1)
        #expect(programs.first?.name == "Echo")
        #expect(programs.first?.source == SamplePrograms.echo.source)
        #expect(programs.first?.createdAt == created)
        #expect(programs.first?.modifiedAt == created)
    }

    @Test func updatingRecordsTheChange() throws {
        let container = try makeContainer()
        let program = SavedProgram(name: "Draft", source: "INP", createdAt: Date(timeIntervalSince1970: 0))
        container.mainContext.insert(program)

        let later = Date(timeIntervalSince1970: 60)
        program.update(source: "INP\nOUT", at: later)
        #expect(program.source == "INP\nOUT")
        #expect(program.modifiedAt == later)
        #expect(program.createdAt == Date(timeIntervalSince1970: 0))
    }

    @Test func schemaListsTheModel() {
        #expect(LMCSchema.models.count == 1)
        #expect(LMCSchema.versionIdentifier == Schema.Version(1, 0, 0))
    }
}
