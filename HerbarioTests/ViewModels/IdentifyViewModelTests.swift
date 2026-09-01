//
//  IdentifyViewModelTests.swift
//  HerbarioTests
//

import Foundation
import Testing
import UIKit
@testable import Herbario

struct IdentifyViewModelTests {
    
    @MainActor
    @Test func testInitialization() {
        let mockService = MockPlantIdentificationService()
        let mockRepository = MockHistoryRepository()
        let viewModel = IdentifyViewModel(identificationService: mockService, historyRepository: mockRepository)
        
        #expect(viewModel.selectedOrgan == .leaf)
        #expect(viewModel.capturedImage == nil)
        #expect(viewModel.state == .idle)
        #expect(viewModel.results.isEmpty)
        #expect(!viewModel.navigateToResults)
        #expect(!viewModel.showSavedToast)
    }
    
    @MainActor
    @Test func testSelectOrgan() {
        let mockService = MockPlantIdentificationService()
        let mockRepository = MockHistoryRepository()
        let viewModel = IdentifyViewModel(identificationService: mockService, historyRepository: mockRepository)
        
        viewModel.selectOrgan(.flower)
        #expect(viewModel.selectedOrgan == .flower)
        
        viewModel.selectOrgan(.fruit)
        #expect(viewModel.selectedOrgan == .fruit)
    }
    
    @MainActor
    @Test func testIdentifySuccess() async throws {
        let mockService = MockPlantIdentificationService()
        let mockRepository = MockHistoryRepository()
        
        let species = SpeciesResult.Species(
            scientificNameWithoutAuthor: "Rosa",
            scientificNameAuthorship: "L.",
            genus: nil,
            family: nil,
            commonNames: ["Rose"]
        )
        
        let result = SpeciesResult(score: 0.95, species: species, images: nil)
        
        mockService.mockResponse = PlantIdentificationResponse(
            query: PlantIdentificationResponse.Query(project: "all", images: nil, organs: nil),
            language: "en",
            preferedReferential: nil,
            results: [result],
            remainingIdentificationRequests: 99
        )
        
        let viewModel = IdentifyViewModel(identificationService: mockService, historyRepository: mockRepository)
        let testImage = UIImage.testImage()
        
        viewModel.setImage(testImage)
        try await Task.sleep(nanoseconds: 100_000_000) // Aguarda processamento
        
        #expect(!viewModel.results.isEmpty)
        #expect(viewModel.state == .idle)
        #expect(viewModel.navigateToResults)
    }
    
    @MainActor
    @Test func testIdentifyFailure() async throws {
        let mockService = MockPlantIdentificationService()
        let mockRepository = MockHistoryRepository()
        
        mockService.shouldThrowError = true
        mockService.throwError = NetworkError.noConnection
        
        let viewModel = IdentifyViewModel(identificationService: mockService, historyRepository: mockRepository)
        let testImage = UIImage.testImage()
        
        viewModel.setImage(testImage)
        try await Task.sleep(nanoseconds: 100_000_000) // Aguarda processamento
        
        #expect(viewModel.results.isEmpty)
        #expect(viewModel.state != .idle)
    }
    
    @MainActor
    @Test func testReset() {
        let mockService = MockPlantIdentificationService()
        let mockRepository = MockHistoryRepository()
        let viewModel = IdentifyViewModel(identificationService: mockService, historyRepository: mockRepository)
        
        let testImage = UIImage.testImage()
        viewModel.capturedImage = testImage
        viewModel.navigateToResults = true
        
        viewModel.reset()
        
        #expect(viewModel.capturedImage == nil)
        #expect(viewModel.results.isEmpty)
        #expect(!viewModel.navigateToResults)
        #expect(viewModel.state == .idle)
    }
    
    @MainActor
    @Test func testDismissError() {
        let mockService = MockPlantIdentificationService()
        let mockRepository = MockHistoryRepository()
        let viewModel = IdentifyViewModel(identificationService: mockService, historyRepository: mockRepository)
        
        // Simular um estado de erro
        // (não há acesso público a state.failure, então testamos o dismissError)
        viewModel.dismissError()
        #expect(viewModel.state == .idle)
    }
}
