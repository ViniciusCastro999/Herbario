import XCTest
@testable import Herbario

class HistoryViewModelTests: XCTestCase {
    
    var viewModel: HistoryViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = HistoryViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialState() {
        // Assert
        XCTAssertEqual(viewModel.identificationHistory.count, 0)
    }
    
    func testAddingIdentification() {
        // Arrange
        let species = PlantIdentificationResponse.Species(
            name: "Rosa sp.",
            scientificNameWithoutAuthor: "Rosa"
        )
        let result = PlantIdentificationResponse.Result(
            score: 0.95,
            species: species,
            gbif: nil
        )
        
        // Act
        let historyItem = IdentificationHistoryItem(
            id: UUID(),
            timestamp: Date(),
            imageData: Data(),
            organ: .leaf,
            topResult: result,
            allResults: [result]
        )
        
        // Assert
        XCTAssertNotNil(historyItem)
        XCTAssertEqual(historyItem.topResult.score, 0.95)
    }
    
    func testHistoryItemOrdering() {
        // Arrange
        let now = Date()
        let item1 = IdentificationHistoryItem(
            id: UUID(),
            timestamp: now.addingTimeInterval(-3600),
            imageData: Data(),
            organ: .leaf,
            topResult: createMockResult(score: 0.8),
            allResults: [createMockResult(score: 0.8)]
        )
        let item2 = IdentificationHistoryItem(
            id: UUID(),
            timestamp: now,
            imageData: Data(),
            organ: .flower,
            topResult: createMockResult(score: 0.9),
            allResults: [createMockResult(score: 0.9)]
        )
        
        let items = [item1, item2]
        
        // Act
        let sorted = items.sorted { $0.timestamp > $1.timestamp }
        
        // Assert
        XCTAssertEqual(sorted.first?.topResult.score, 0.9)
        XCTAssertEqual(sorted.last?.topResult.score, 0.8)
    }
    
    // MARK: - Helper Methods
    
    private func createMockResult(score: Double) -> PlantIdentificationResponse.Result {
        return PlantIdentificationResponse.Result(
            score: score,
            species: .init(name: "Mock Plant", scientificNameWithoutAuthor: "MockPlant"),
            gbif: nil
        )
    }
}
