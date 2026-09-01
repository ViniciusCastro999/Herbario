//
//  HistoryViewModel.swift
//  Herbario
//

import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {

    @Published private(set) var items: [IdentificationHistoryItem] = []
    @Published private(set) var errorMessage: String?

    private let historyRepository: HistoryRepository

    var isEmpty: Bool { items.isEmpty }

    init(historyRepository: HistoryRepository) {
        self.historyRepository = historyRepository
    }

    func load() {
        do {
            items = try historyRepository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = "Não foi possível carregar o histórico."
        }
    }

    func delete(_ item: IdentificationHistoryItem) {
        do {
            try historyRepository.delete(item)
            items.removeAll { $0.id == item.id }
        } catch {
            errorMessage = "Não foi possível remover este item."
        }
    }

    func delete(at offsets: IndexSet) {
        offsets.map { items[$0] }.forEach(delete)
    }
}
