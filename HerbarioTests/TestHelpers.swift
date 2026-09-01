//
//  TestHelpers.swift
//  HerbarioTests
//

import Foundation
import UIKit
@testable import Herbario

// MARK: - Mock Repositories

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

// MARK: - Mock Services

final class MockPlantIdentificationService: PlantIdentificationServicing {
    var mockResponse: PlantIdentificationResponse?
    var shouldThrowError = false
    var throwError: Error?
    
    func identify(images: [PlantImageInput]) async throws -> PlantIdentificationResponse {
        if shouldThrowError {
            throw throwError ?? NSError(domain: "MockError", code: -1)
        }
        return mockResponse ?? PlantIdentificationResponse(
            query: PlantIdentificationResponse.Query(project: "all", images: nil, organs: nil),
            language: "en",
            preferedReferential: nil,
            results: [],
            remainingIdentificationRequests: 100
        )
    }
}

// MARK: - Test Image Helpers

extension UIImage {
    static func testImage(size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.blue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
