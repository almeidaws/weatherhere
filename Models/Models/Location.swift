//
//  Location.swift
//  Models
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

public struct Location: Codable, Hashable, Comparable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public static func < (lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude ? lhs.longitude < rhs.longitude : lhs.latitude < rhs.latitude
    }
}
