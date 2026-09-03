import Foundation
@preconcurrency import SwiftData

typealias SavedProgram = LMCSchema.SavedProgram

extension LMCSchema {
    /// A program the user saved from the editor.
    @Model
    class SavedProgram {
        var name: String
        var source: String
        var createdAt: Date
        var modifiedAt: Date

        init(name: String, source: String, createdAt: Date = .now) {
            self.name = name
            self.source = source
            self.createdAt = createdAt
            self.modifiedAt = createdAt
        }

        /// Replaces the source and records when it changed.
        func update(source: String, at date: Date = .now) {
            self.source = source
            modifiedAt = date
        }
    }
}
