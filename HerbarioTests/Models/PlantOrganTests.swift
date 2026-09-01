//
//  PlantOrganTests.swift
//  HerbarioTests
//

import Foundation
import Testing
@testable import Herbario

struct PlantOrganTests {
    
    @Test func testAllCases() {
        let cases = PlantOrgan.allCases
        #expect(cases.count == 6)
        #expect(cases.contains(.flower))
        #expect(cases.contains(.leaf))
        #expect(cases.contains(.fruit))
        #expect(cases.contains(.bark))
        #expect(cases.contains(.habit))
        #expect(cases.contains(.other))
    }
    
    @Test func testDisplayNames() {
        #expect(PlantOrgan.flower.displayName == "Flor")
        #expect(PlantOrgan.leaf.displayName == "Folha")
        #expect(PlantOrgan.fruit.displayName == "Fruto")
        #expect(PlantOrgan.bark.displayName == "Casca")
        #expect(PlantOrgan.habit.displayName == "Planta inteira")
        #expect(PlantOrgan.other.displayName == "Outro")
    }
    
    @Test func testSymbolNames() {
        #expect(PlantOrgan.flower.symbolName == "camera.macro")
        #expect(PlantOrgan.leaf.symbolName == "leaf.fill")
        #expect(PlantOrgan.fruit.symbolName == "circle.grid.2x2.fill")
        #expect(PlantOrgan.bark.symbolName == "tree.fill")
        #expect(PlantOrgan.habit.symbolName == "photo.fill")
        #expect(PlantOrgan.other.symbolName == "questionmark.circle.fill")
    }
    
    @Test func testApiValues() {
        #expect(PlantOrgan.flower.apiValue == "flower")
        #expect(PlantOrgan.leaf.apiValue == "leaf")
        #expect(PlantOrgan.fruit.apiValue == "fruit")
        #expect(PlantOrgan.bark.apiValue == "bark")
        #expect(PlantOrgan.habit.apiValue == "habit")
        #expect(PlantOrgan.other.apiValue == "other")
    }
    
    @Test func testIdentifiable() {
        let organ = PlantOrgan.leaf
        #expect(organ.id == "leaf")
    }
    
    @Test func testCodable() throws {
        let organ = PlantOrgan.flower
        let encoded = try JSONEncoder().encode(organ)
        let decoded = try JSONDecoder().decode(PlantOrgan.self, from: encoded)
        #expect(decoded == organ)
    }
}
