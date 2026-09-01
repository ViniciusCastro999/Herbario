//
//  PlantOrgan.swift
//  Herbario
//
//  Representa os "órgãos" da planta aceitos pela API do PlantNet.
//  Ver: https://my.plantnet.org/doc/getting-started/introduction
//

import Foundation

enum PlantOrgan: String, CaseIterable, Identifiable, Codable {
    case flower
    case leaf
    case fruit
    case bark
    case habit
    case other

    var id: String { rawValue }

    /// Valor exato esperado pela API do PlantNet no campo "organs".
    var apiValue: String { rawValue }

    var displayName: String {
        switch self {
        case .flower: return "Flor"
        case .leaf:   return "Folha"
        case .fruit:  return "Fruto"
        case .bark:   return "Casca"
        case .habit:  return "Planta inteira"
        case .other:  return "Outro"
        }
    }

    var symbolName: String {
        switch self {
        case .flower: return "camera.macro"
        case .leaf:   return "leaf.fill"
        case .fruit:  return "circle.grid.2x2.fill"
        case .bark:   return "tree.fill"
        case .habit:  return "photo.fill"
        case .other:  return "questionmark.circle.fill"
        }
    }
}
