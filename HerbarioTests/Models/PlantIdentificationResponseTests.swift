//
//  PlantIdentificationResponseTests.swift
//  HerbarioTests
//

import Foundation
import Testing
@testable import Herbario

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
    
    @Test func testSpeciesResultIdentifiable() {
        let species = SpeciesResult.Species(
            scientificNameWithoutAuthor: "Rosa",
            scientificNameAuthorship: "L.",
            genus: nil,
            family: nil,
            commonNames: nil
        )
        
        let result = SpeciesResult(score: 0.95, species: species, images: nil)
        #expect(result.id.contains("Rosa"))
    }
}
