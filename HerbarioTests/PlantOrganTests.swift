import XCTest
@testable import Herbario

class PlantOrganTests: XCTestCase {
    
    func testAllOrganCases() {
        // Assert
        let organs: [PlantOrgan] = [.leaf, .flower, .fruit, .stem, .bark, .branch, .flowerBud, .other]
        XCTAssertEqual(organs.count, 8)
    }
    
    func testOrganDisplayNames() {
        // Assert
        XCTAssertEqual(PlantOrgan.leaf.displayName, "Leaf")
        XCTAssertEqual(PlantOrgan.flower.displayName, "Flower")
        XCTAssertEqual(PlantOrgan.fruit.displayName, "Fruit")
        XCTAssertEqual(PlantOrgan.stem.displayName, "Stem")
    }
    
    func testOrganCodable() {
        // Arrange
        let organs: [PlantOrgan] = [.leaf, .flower, .fruit]
        
        // Act & Assert
        for organ in organs {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()
            
            let data = try! encoder.encode(organ)
            let decoded = try! decoder.decode(PlantOrgan.self, from: data)
            
            XCTAssertEqual(organ, decoded)
        }
    }
}
