//
//  PlantImageInputTests.swift
//  HerbarioTests
//

import Foundation
import Testing
import UIKit
@testable import Herbario

struct PlantImageInputTests {
    
    @Test func testPlantImageInputInitialization() {
        let testImage = UIImage.testImage()
        let input = PlantImageInput(organ: .leaf, image: testImage)
        
        #expect(input.organ == .leaf)
        #expect(input.image == testImage)
    }
    
    @Test func testPlantImageInputWithDifferentOrgans() {
        let testImage = UIImage.testImage()
        
        for organ in PlantOrgan.allCases {
            let input = PlantImageInput(organ: organ, image: testImage)
            #expect(input.organ == organ)
            #expect(input.image == testImage)
        }
    }
}
