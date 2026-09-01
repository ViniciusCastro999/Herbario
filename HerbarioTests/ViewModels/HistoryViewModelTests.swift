//
//  HistoryViewModelTests.swift
//  HerbarioTests
//

import Foundation
import Testing
@testable import Herbario

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
    
    @MainActor
    @Test func testDeleteItemError() {
        let item = IdentificationHistoryItem(
            scientificName: "Rosa sp.",
            commonName: nil,
            family: nil,
            scorePercent: 85,
            imageData: "test".data(using: .utf8)!,
            rawResponseData: nil
        )
        
        let mockRepository = MockHistoryRepository()
        mockRepository.items = [item]
        mockRepository.shouldThrowError = true
        
        let viewModel = HistoryViewModel(historyRepository: mockRepository)
        viewModel.load()
        
        viewModel.delete(item)
        #expect(viewModel.errorMessage == "Não foi possível remover este item.")
    }
}
