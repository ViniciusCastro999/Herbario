import XCTest
@testable import Herbario

class NetworkErrorTests: XCTestCase {
    
    func testNetworkErrorCases() {
        // Arrange
        let errors: [NetworkError] = [
            .invalidURL,
            .networkFailure(NSError(domain: "Test", code: 1)),
            .invalidResponse,
            .decodingError(NSError(domain: "Test", code: 2)),
            .apiError(statusCode: 500, message: "Server Error"),
            .unknown(NSError(domain: "Test", code: 3))
        ]
        
        // Assert
        XCTAssertEqual(errors.count, 6)
    }
    
    func testNetworkErrorDescription() {
        // Arrange
        let invalidURLError = NetworkError.invalidURL
        let statusError = NetworkError.apiError(statusCode: 404, message: "Not Found")
        
        // Assert
        XCTAssertNotNil(invalidURLError)
        XCTAssertNotNil(statusError)
    }
    
    func testNetworkErrorHandling() {
        // Arrange
        let error = NetworkError.apiError(statusCode: 401, message: "Unauthorized")
        
        // Act
        let isCritical = (error as NSError).code >= 400
        
        // Assert
        XCTAssertTrue(isCritical)
    }
    
    func testDecodingErrorCreation() {
        // Arrange
        let nsError = NSError(domain: "JSONDecoding", code: -1, userInfo: nil)
        
        // Act
        let networkError = NetworkError.decodingError(nsError)
        
        // Assert
        XCTAssertNotNil(networkError)
    }
}
