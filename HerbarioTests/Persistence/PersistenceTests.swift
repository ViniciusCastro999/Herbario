//
//  PersistenceTests.swift
//  HerbarioTests
//

import Foundation
import Testing
import SwiftData
@testable import Herbario

struct PersistenceTests {
    
    @Test func testIdentificationHistoryItemModelProperties() {
        let imageData = "test".data(using: .utf8)!
        let date = Date()
        let id = UUID()
        
        let item = IdentificationHistoryItem(
            id: id,
            date: date,
            scientificName: "Test Species",
            commonName: "Test Common",
            family: "Test Family",
            scorePercent: 75,
            imageData: imageData,
            rawResponseData: nil
        )
        
        #expect(item.id == id)
        #expect(item.date == date)
        #expect(item.scientificName == "Test Species")
        #expect(item.commonName == "Test Common")
        #expect(item.family == "Test Family")
        #expect(item.scorePercent == 75)
        #expect(item.imageData == imageData)
        #expect(item.rawResponseData == nil)
    }
    
    @Test func testHistoryItemWithoutOptionalFields() {
        let imageData = "test".data(using: .utf8)!
        
        let item = IdentificationHistoryItem(
            scientificName: "Species",
            commonName: nil,
            family: nil,
            scorePercent: 50,
            imageData: imageData,
            rawResponseData: nil
        )
        
        #expect(item.scientificName == "Species")
        #expect(item.commonName == nil)
        #expect(item.family == nil)
        #expect(item.scorePercent == 50)
    }
    
    @Test func testHistoryItemScorePercentBoundaries() {
        let imageData = "test".data(using: .utf8)!
        
        let item0 = IdentificationHistoryItem(
            scientificName: "Zero Score",
            commonName: nil,
            family: nil,
            scorePercent: 0,
            imageData: imageData,
            rawResponseData: nil
        )
        #expect(item0.scorePercent == 0)
        
        let item100 = IdentificationHistoryItem(
            scientificName: "Perfect Score",
            commonName: nil,
            family: nil,
            scorePercent: 100,
            imageData: imageData,
            rawResponseData: nil
        )
        #expect(item100.scorePercent == 100)
    }
}
