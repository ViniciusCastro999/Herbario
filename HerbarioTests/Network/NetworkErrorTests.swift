//
//  NetworkErrorTests.swift
//  HerbarioTests
//

import Foundation
import Testing
@testable import Herbario

struct NetworkErrorTests {
    
    @Test func testMissingAPIKeyError() {
        let error = NetworkError.missingAPIKey
        #expect(error.errorDescription == "Chave de API do PlantNet não configurada.")
    }
    
    @Test func testInvalidURLError() {
        let error = NetworkError.invalidURL
        #expect(error.errorDescription == "URL inválida para a requisição.")
    }
    
    @Test func testInvalidImageError() {
        let error = NetworkError.invalidImage
        #expect(error.errorDescription == "Não foi possível processar a imagem selecionada.")
    }
    
    @Test func testNoConnectionError() {
        let error = NetworkError.noConnection
        #expect(error.errorDescription == "Sem conexão com a internet. Verifique sua rede e tente novamente.")
    }
    
    @Test func testServer429Error() {
        let error = NetworkError.server(statusCode: 429, message: nil)
        #expect(error.errorDescription == "Limite de identificações atingido por hoje. Tente novamente mais tarde.")
    }
    
    @Test func testServerError() {
        let error = NetworkError.server(statusCode: 500, message: "Internal Server Error")
        #expect(error.errorDescription == "Internal Server Error")
    }
    
    @Test func testServerErrorNoMessage() {
        let error = NetworkError.server(statusCode: 500, message: nil)
        #expect(error.errorDescription == "O servidor retornou um erro (código 500).")
    }
    
    @Test func testServerError400() {
        let error = NetworkError.server(statusCode: 400, message: "Bad Request")
        #expect(error.errorDescription == "Bad Request")
    }
    
    @Test func testDecodingError() {
        let underlyingError = NSError(domain: "test", code: 0)
        let error = NetworkError.decoding(underlyingError)
        #expect(error.errorDescription == "Não foi possível interpretar a resposta do servidor.")
    }
    
    @Test func testUnknownError() {
        let underlyingError = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        let error = NetworkError.unknown(underlyingError)
        #expect(error.errorDescription == "Test error")
    }
}
