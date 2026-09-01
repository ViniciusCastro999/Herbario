//
//  HistoryRepository.swift
//  Herbario
//
//  Abstrai o armazenamento do histórico. A camada de ViewModel não
//  sabe (nem precisa saber) que por baixo dos panos é SwiftData.
//

import Foundation

protocol HistoryRepository {
    func fetchAll() throws -> [IdentificationHistoryItem]
    func save(_ item: IdentificationHistoryItem) throws
    func delete(_ item: IdentificationHistoryItem) throws
}
