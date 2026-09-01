//
//  HerbarioTests.swift
//  HerbarioTests
//
//  Created by Vinicius Cardoso de Castro on 01/09/26.
//

import Testing
import UIKit
@testable import Herbario

// MARK: - Models Tests

struct IdentificationHistoryItemTests {
    
    @Test func testInitialization() {
        let imageData = "test".data(using: .utf8)!
        let date = Date()
        
        let item = IdentificationHistoryItem(
            date: date,
            scientificName: "Rosa sp.",
            commonName: "Rosa",
            family: "Rosaceae",
            scorePercent: 85,
            imageData: imageData,
            rawResponseData: nil
        )
        
        #expect(item.scientificName == "Rosa sp.")
        #expect(item.commonName == "Rosa")
        #expect(item.family == "Rosaceae")
        #expect(item.scorePercent == 85)
        #expect(item.imageData == imageData)
        #expect(item.date == date)
    }
    
    @Test func testDecodedResponseWithoutData() {
        let imageData = "test".data(using: .utf8)!
        let item = IdentificationHistoryItem(
            scientificName: "Rosa sp.",
            commonName: nil,
            family: nil,
            scorePercent: 80,
            imageData: imageData,
            rawResponseData: nil
        )
        
        #expect(item.decodedResponse == nil)
    }
    
    @Test func testDecodedResponseWithValidData() {
        let imageData = "test".data(using: .utf8)!
        
        let response = PlantIdentificationResponse(
            query: PlantIdentificationResponse.Query(project: "all", images: nil, organs: nil),
            language: "en",
            preferedReferential: nil,
            results: [],
            remainingIdentificationRequests: 100
        )
        
        let rawData = try? JSONEncoder().encode(response)
        
        let item = IdentificationHistoryItem(
            scientificName: "Rosa sp.",
            commonName: nil,
            family: nil,
            scorePercent: 80,
            imageData: imageData,
            rawResponseData: rawData
        )
        
        #expect(item.decodedResponse != nil)
        #expect(item.decodedResponse?.language == "en")
    }
}

struct PlantOrganTests {
    
    @Test func testAllCases() {
        let cases = PlantOrgan.allCases
        #expect(cases.count == 6)
        #expect(cases.contains(.flower))
        #expect(cases.contains(.leaf))
        #expect(cases.contains(.fruit))
        #expect(cases.contains(.bark))
        #expect(cases.contains(.habit))
        #expect(cases.contains(.other))
    }
    
    @Test func testDisplayNames() {
        #expect(PlantOrgan.flower.displayName == "Flor")
        #expect(PlantOrgan.leaf.displayName == "Folha")
        #expect(PlantOrgan.fruit.displayName == "Fruto")
        #expect(PlantOrgan.bark.displayName == "Casca")
        #expect(PlantOrgan.habit.displayName == "Planta inteira")
        #expect(PlantOrgan.other.displayName == "Outro")
    }
    
    @Test func testSymbolNames() {
        #expect(PlantOrgan.flower.symbolName == "camera.macro")
        #expect(PlantOrgan.leaf.symbolName == "leaf.fill")
        #expect(PlantOrgan.fruit.symbolName == "circle.grid.2x2.fill")
        #expect(PlantOrgan.bark.symbolName == "tree.fill")
        #expect(PlantOrgan.habit.symbolName == "photo.fill")
        #expect(PlantOrgan.other.symbolName == "questionmark.circle.fill")
    }
    
    @Test func testApiValues() {
        #expect(PlantOrgan.flower.apiValue == "flower")
        #expect(PlantOrgan.leaf.apiValue == "leaf")
        #expect(PlantOrgan.fruit.apiValue == "fruit")
        #expect(PlantOrgan.bark.apiValue == "bark")
        #expect(PlantOrgan.habit.apiValue == "habit")
        #expect(PlantOrgan.other.apiValue == "other")
    }
    
    @Test func testIdentifiable() {
        let organ = PlantOrgan.leaf
        #expect(organ.id == "leaf")
    }
    
    @Test func testCodable() throws {
        let organ = PlantOrgan.flower
        let encoded = try JSONEncoder().encode(organ)
        let decoded = try JSONDecoder().decode(PlantOrgan.self, from: encoded)
        #expect(decoded == organ)
    }
}

struct PlantIdentificationResponseTests {
    
    @Test func testCodableWithValidJSON() throws {
        let json = """
        {
            "query": {
                "project": "all",
                "images": null,
                "organs": null
            },
            "language": "en",
            "preferedReferential": null,
            "results": [],
            "remainingIdentificationRequests": 100
        }
        """.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(PlantIdentificationResponse.self, from: json)
        #expect(response.language == "en")
        #expect(response.remainingIdentificationRequests == 100)
        #expect(response.results.isEmpty)
    }
    
    @Test func testSpeciesResultEquatable() {
        let species1 = SpeciesResult.Species(
            scientificNameWithoutAuthor: "Rosa",
            scientificNameAuthorship: "L.",
            genus: nil,
            family: nil,
            commonNames: ["Rose"]
        )
        
        let result1 = SpeciesResult(
            score: 0.95,
            species: species1,
            images: nil
        )
        
        let species2 = SpeciesResult.Species(
            scientificNameWithoutAuthor: "Rosa",
            scientificNameAuthorship: "L.",
            genus: nil,
            family: nil,
            commonNames: ["Rose"]
        )
        
        let result2 = SpeciesResult(
            score: 0.95,
            species: species2,
            images: nil
        )
        
        #expect(result1 == result2)
    }
}

// MARK: - ViewModels Tests

struct HistoryViewModelTests {
    
    @MainActor
    @Test func testHistoryViewModelInitialization() {
        let mockRepository = MockHistoryRepository()
        let viewModel = HistoryViewModel(historyRepository: mockRepository)
        
        #expect(viewModel.isEmpty)
        #expect(viewModel.items.isEmpty)
        #expect(viewModel.errorMessage == nil)
    }
    
    @MainActor
    @Test func testLoadHistorySuccess() {
        let mockRepository = MockHistoryRepository()
        mockRepository.items = [
            IdentificationHistoryItem(
                scientificName: "Rosa sp.",
                commonName: "Rosa",
                family: "Rosaceae",
                scorePercent: 85,
                imageData: "test1".data(using: .utf8)!,
                rawResponseData: nil
            ),
            IdentificationHistoryItem(
                scientificName: "Tulipa sp.",
                commonName: "Tulipa",
                family: "Liliaceae",
                scorePercent: 90,
                imageData: "test2".data(using: .utf8)!,
                rawResponseData: nil
            )
        ]
        
        let viewModel = HistoryViewModel(historyRepository: mockRepository)
        viewModel.load()
        
        #expect(!viewModel.isEmpty)
        #expect(viewModel.items.count == 2)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.items.first?.scientificName == "Rosa sp.")
    }
    
    @MainActor
    @Test func testLoadHistoryFailure() {
        let mockRepository = MockHistoryRepository()
        mockRepository.shouldThrowError = true
        
        let viewModel = HistoryViewModel(historyRepository: mockRepository)
        viewModel.load()
        
        #expect(viewModel.isEmpty)
        #expect(viewModel.errorMessage == "Não foi possível carregar o histórico.")
    }
    
    @MainActor
    @Test func testDeleteItem() {
        let item1 = IdentificationHistoryItem(
            scientificName: "Rosa sp.",
            commonName: "Rosa",
            family: "Rosaceae",
            scorePercent: 85,
            imageData: "test1".data(using: .utf8)!,
            rawResponseData: nil
        )
        
        let item2 = IdentificationHistoryItem(
            scientificName: "Tulipa sp.",
            commonName: "Tulipa",
            family: "Liliaceae",
            scorePercent: 90,
            imageData: "test2".data(using: .utf8)!,
            rawResponseData: nil
        )
        
        let mockRepository = MockHistoryRepository()
        mockRepository.items = [item1, item2]
        
        let viewModel = HistoryViewModel(historyRepository: mockRepository)
        viewModel.load()
        #expect(viewModel.items.count == 2)
        
        viewModel.delete(item1)
        #expect(viewModel.items.count == 1)
        #expect(viewModel.items.first?.scientificName == "Tulipa sp.")
    }
    
    @MainActor
    @Test func testDeleteAtOffsets() {
        let mockRepository = MockHistoryRepository()
        mockRepository.items = [
            IdentificationHistoryItem(
                scientificName: "Rosa sp.",
                commonName: nil,
                family: nil,
                scorePercent: 85,
                imageData: "test1".data(using: .utf8)!,
                rawResponseData: nil
            ),
            IdentificationHistoryItem(
                scientificName: "Tulipa sp.",
                commonName: nil,
                family: nil,
                scorePercent: 90,
                imageData: "test2".data(using: .utf8)!,
                rawResponseData: nil
            ),
            IdentificationHistoryItem(
                scientificName: "Orquídea sp.",
                commonName: nil,
                family: nil,
                scorePercent: 88,
                imageData: "test3".data(using: .utf8)!,
                rawResponseData: nil
            )
        ]
        
        let viewModel = HistoryViewModel(historyRepository: mockRepository)
        viewModel.load()
        #expect(viewModel.items.count == 3)
        
        viewModel.delete(at: IndexSet(integer: 0))
        #expect(viewModel.items.count == 2)
        #expect(viewModel.items.first?.scientificName == "Tulipa sp.")
    }
}

// MARK: - Network Error Tests

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
    
    @Test func testDecodingError() {
        let underlyingError = NSError(domain: "test", code: 0)
        let error = NetworkError.decoding(underlyingError)
        #expect(error.errorDescription == "Não foi possível interpretar a resposta do servidor.")
    }
}

// MARK: - Mock Objects

final class MockHistoryRepository: HistoryRepository {
    var items: [IdentificationHistoryItem] = []
    var shouldThrowError = false
    
    func fetchAll() throws -> [IdentificationHistoryItem] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1)
        }
        return items
    }
    
    func save(_ item: IdentificationHistoryItem) throws {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1)
        }
        items.append(item)
    }
    
    func delete(_ item: IdentificationHistoryItem) throws {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1)
        }
        items.removeAll { $0.id == item.id }
    }
}
