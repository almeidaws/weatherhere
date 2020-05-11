//
//  DistanceMeasureable.swift
//  Models
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

public protocol DistanceMeasureable {
    static func distance(_ lhs: Self, _ rhs: Self) -> Double
}

public extension DistanceMeasureable {
    func distance(to point: Self) -> Double {
        return Self.distance(self, point)
    }
}
