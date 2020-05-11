//
//  ModelsTests.swift
//  ModelsTests
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import XCTest
@testable import Models

class ModelsTests: XCTestCase {

    func testDistanceBetweenLocations() {
        let location1 = Location(latitude: 44.5, longitude: -12.54)
        let location2 = Location(latitude: 12.13, longitude: 78.5)
        let distance = 96.62
        let calculatedDistance = location1.distance(to: location2)
        XCTAssert(Double(String(format: "%.2f", calculatedDistance))! == distance, "Distance between locations calculated incorrectly.")
    }

    func testSymmetryBetweenLocationDistances() {
        let location1 = Location(latitude: 44.5, longitude: -12.54)
        let location2 = Location(latitude: 12.13, longitude: 78.5)
        XCTAssert(location1.distance(to: location2) == location2.distance(to: location1), "Distance between locations isn't symmetric.")
    }
}
