//
//  Location.swift
//  Models
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

public struct Location: Codable, Hashable, DistanceMeasureable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public static func distance(_ lhs: Location, _ rhs: Location) -> Double {
        let dx = abs(rhs.longitude - lhs.longitude)
        let dy = abs(rhs.latitude - lhs.latitude)
        return sqrt(dx * dx + dy * dy)
    }
}

extension Array where Element == Location {
    func sorted(distanceTo location: Location) -> [Location] {
        return sorted { (w1, w2) -> Bool in
            let d1 = w1.distance(to: location)
            let d2 = w2.distance(to: location)
            return d1 < d2
        }
    }
}
