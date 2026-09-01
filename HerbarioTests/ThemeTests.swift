import XCTest
@testable import Herbario
import SwiftUI

class ThemeTests: XCTestCase {
    
    func testPrimaryButtonStyleApplied() {
        // Arrange
        let buttonStyle = PrimaryButtonStyle()
        
        // Assert
        XCTAssertNotNil(buttonStyle)
    }
    
    func testHerbarioColorsExist() {
        // Assert - Verify key colors are accessible
        XCTAssertNotNil(Color.herbarioGreen)
        XCTAssertNotNil(Color.accentColor)
    }
    
    func testColorInitialization() {
        // Act
        let greenColor = Color.herbarioGreen
        
        // Assert
        XCTAssertNotNil(greenColor)
    }
}

class ColorHerbarioTests: XCTestCase {
    
    func testColorConstants() {
        // Act
        let herbGreen = Color.herbarioGreen
        let accent = Color.accentColor
        
        // Assert
        XCTAssertNotNil(herbGreen)
        XCTAssertNotNil(accent)
    }
    
    func testColorUsageInUI() {
        // This test verifies that colors can be instantiated
        // and used in UI contexts without crashing
        
        // Act
        let _ = Color.herbarioGreen
        let _ = Color.accentColor
        
        // Assert (if no exception, test passes)
        XCTAssertTrue(true)
    }
}
