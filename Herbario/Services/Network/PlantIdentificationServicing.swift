//
//  PlantIdentificationServicing.swift
//  Herbario
//
//  Abstração da fonte de dados de identificação. A ViewModel depende
//  apenas deste protocolo — nunca da implementação concreta (PlantNetAPIService).
//  Isso permite trocar de provedor ou injetar um mock nos testes/Previews.
//

import UIKit

struct PlantImageInput {
    let organ: PlantOrgan
    let image: UIImage
}

protocol PlantIdentificationServicing {
    func identify(images: [PlantImageInput]) async throws -> PlantIdentificationResponse
}
