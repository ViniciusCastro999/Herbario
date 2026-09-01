//
//  PlantIdentificationResponse.swift
//  Herbario
//
//  Modelos que espelham fielmente o JSON devolvido por
//  POST https://my-api.plantnet.org/v2/identify/{project}
//

import Foundation

struct PlantIdentificationResponse: Codable, Equatable {
    let query: Query
    let language: String?
    let preferedReferential: String?
    let results: [SpeciesResult]
    let remainingIdentificationRequests: Int?

    struct Query: Codable, Equatable {
        let project: String?
        let images: [String]?
        let organs: [String]?
    }
}

struct SpeciesResult: Codable, Equatable, Identifiable {
    let score: Double
    let species: Species
    /// Fotos de referência da espécie devolvidas pela própria API do PlantNet
    /// (fotos de observações reais usadas para treinar/comparar o modelo).
    let images: [ReferenceImage]?

    // Estável o suficiente para uso em List/ForEach.
    var id: String { species.scientificNameWithoutAuthor + String(format: "%.6f", score) }

    struct Species: Codable, Equatable {
        let scientificNameWithoutAuthor: String
        let scientificNameAuthorship: String?
        let genus: Taxon?
        let family: Taxon?
        let commonNames: [String]?

        struct Taxon: Codable, Equatable {
            let scientificNameWithoutAuthor: String
            let scientificNameAuthorship: String?
        }
    }

    struct ReferenceImage: Codable, Equatable {
        let organ: String?
        let author: String?
        let license: String?
        let citation: String?
        let url: ImageURLs

        struct ImageURLs: Codable, Equatable {
            /// "o" = original, "m" = médio, "s" = pequeno (miniatura).
            let o: String?
            let m: String?
            let s: String?
        }
    }

    /// Score em porcentagem, pronto pra exibir na UI (ex.: "82%").
    var scorePercentText: String {
        "\(Int((score * 100).rounded()))%"
    }

    var primaryCommonName: String? {
        species.commonNames?.first
    }

    /// Melhor URL disponível para exibir como thumbnail nas listas.
    var thumbnailImageURL: URL? {
        guard let first = images?.first else { return nil }
        let raw = first.url.m ?? first.url.s ?? first.url.o
        return raw.flatMap(URL.init(string:))
    }
}
