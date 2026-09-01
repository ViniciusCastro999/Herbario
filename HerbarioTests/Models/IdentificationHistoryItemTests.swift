//
//  IdentificationHistoryItemTests.swift
//  HerbarioTests
//

import Foundation
import Testing
@testable import Herbario

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
