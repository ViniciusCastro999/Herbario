//
//  IdentificationHistoryItem.swift
//  Herbario
//
//  Entidade persistida localmente (SwiftData) toda vez que o usuário
//  salva uma identificação no histórico.
//

import Foundation
import SwiftData

@Model
final class IdentificationHistoryItem {
    @Attribute(.unique) var id: UUID
    var date: Date
    var scientificName: String
    var commonName: String?
    var family: String?
    var scorePercent: Int
    /// JPEG comprimido da primeira foto usada na identificação (thumbnail).
    var imageData: Data
    /// Resposta completa da API serializada, para reabrir o detalhe
    /// com todos os candidatos, sem precisar chamar a API de novo.
    var rawResponseData: Data?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        scientificName: String,
        commonName: String?,
        family: String?,
        scorePercent: Int,
        imageData: Data,
        rawResponseData: Data?
    ) {
        self.id = id
        self.date = date
        self.scientificName = scientificName
        self.commonName = commonName
        self.family = family
        self.scorePercent = scorePercent
        self.imageData = imageData
        self.rawResponseData = rawResponseData
    }

    var decodedResponse: PlantIdentificationResponse? {
        guard let rawResponseData else { return nil }
        return try? JSONDecoder().decode(PlantIdentificationResponse.self, from: rawResponseData)
    }
}
