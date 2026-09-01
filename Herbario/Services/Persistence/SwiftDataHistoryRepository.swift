//
//  SwiftDataHistoryRepository.swift
//  Herbario
//

import Foundation
import SwiftData

final class SwiftDataHistoryRepository: HistoryRepository {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() throws -> [IdentificationHistoryItem] {
        let descriptor = FetchDescriptor<IdentificationHistoryItem>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func save(_ item: IdentificationHistoryItem) throws {
        modelContext.insert(item)
        try modelContext.save()
    }

    func delete(_ item: IdentificationHistoryItem) throws {
        modelContext.delete(item)
        try modelContext.save()
    }
}
