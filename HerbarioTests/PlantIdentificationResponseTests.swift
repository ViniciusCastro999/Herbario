import XCTest
@testable import Herbario

class PlantIdentificationResponseTests: XCTestCase {
    
    func testDecodingValidResponse() {
        // Arrange
        let jsonData = """
        {
            "results": [
                {
                    "score": 0.95,
                    "species": {
                        "name": "Rosa sp.",
                        "scientificNameWithoutAuthor": "Rosa"
                    },
                    "gbif": {
                        "id": 2884521
                    }
                }
            ],
            "query": {
                "project": "all",
                "includeClosedLeaves": false
            }
        }
        """.data(using: .utf8)!
        
        // Act
        let decoder = JSONDecoder()
        let response = try? decoder.decode(PlantIdentificationResponse.self, from: jsonData)
        
        // Assert
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.results.count, 1)
        XCTAssertEqual(response?.results.first?.score, 0.95)
        XCTAssertEqual(response?.results.first?.species.name, "Rosa sp.")
    }
    
    func testDecodingEmptyResults() {
        // Arrange
        let jsonData = """
        {
            "results": [],
            "query": {
                "project": "all",
                "includeClosedLeaves": false
            }
        }
        """.data(using: .utf8)!
        
        // Act
        let decoder = JSONDecoder()
        let response = try? decoder.decode(PlantIdentificationResponse.self, from: jsonData)
        
        // Assert
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.results.count, 0)
    }
    
    func testHighestScoreResult() {
        // Arrange
        let result1 = PlantIdentificationResponse.Result(
            score: 0.75,
            species: .init(name: "Planta A", scientificNameWithoutAuthor: "PlantaA"),
            gbif: nil
        )
        let result2 = PlantIdentificationResponse.Result(
            score: 0.95,
            species: .init(name: "Planta B", scientificNameWithoutAuthor: "PlantaB"),
            gbif: nil
        )
        let results = [result1, result2]
        
        // Act
        let highest = results.max(by: { $0.score < $1.score })
        
        // Assert
        XCTAssertEqual(highest?.score, 0.95)
        XCTAssertEqual(highest?.species.name, "Planta B")
    }
}
