//
//  NetworkError.swift
//  Herbario
//

import Foundation

enum NetworkError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case invalidImage
    case noConnection
    case server(statusCode: Int, message: String?)
    case decoding(Error)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Chave de API do PlantNet não configurada."
        case .invalidURL:
            return "URL inválida para a requisição."
        case .invalidImage:
            return "Não foi possível processar a imagem selecionada."
        case .noConnection:
            return "Sem conexão com a internet. Verifique sua rede e tente novamente."
        case .server(let statusCode, let message):
            if statusCode == 429 {
                return "Limite de identificações atingido por hoje. Tente novamente mais tarde."
            }
            return message ?? "O servidor retornou um erro (código \(statusCode))."
        case .decoding:
            return "Não foi possível interpretar a resposta do servidor."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
