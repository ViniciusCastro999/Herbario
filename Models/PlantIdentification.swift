import Foundation
import UIKit

/// Mirrors the JSON schema requested from the model in `ClaudeAPIService`.
struct PlantIdentification: Codable, Equatable {
    let encontrada: Bool
    let nomeComum: String?
    let nomeCientifico: String?
    let familia: String?
    let tipo: String?
    let confianca: String?
    let descricao: String?
    let cuidados: [String]?
    let curiosidade: String?
    let toxicidade: String?
    let motivo: String?

    enum CodingKeys: String, CodingKey {
        case encontrada
        case nomeComum = "nome_comum"
        case nomeCientifico = "nome_cientifico"
        case familia
        case tipo
        case confianca
        case descricao
        case cuidados
        case curiosidade
        case toxicidade
        case motivo
    }
}

/// One saved identification, paired with the photo the user captured.
/// Kept separate from `PlantIdentification` so the network model can stay
/// a plain `Codable` without fighting `Identifiable` synthesis.
struct HistoryEntry: Identifiable {
    let id = UUID()
    let image: UIImage
    let result: PlantIdentification
    let date: Date
}
