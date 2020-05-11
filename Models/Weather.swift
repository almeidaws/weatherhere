//
//  Weather.swift
//  Models
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

public struct Weather: Codable, Hashable, Comparable {
    public let place: String
    public let location: Location
    public let temperature: Temperature
    public let sky: String
    
    public init(place: String, location: Location, temperature: Temperature, sky: String) {
        self.place = place
        self.location = location
        self.temperature = temperature
        self.sky = sky
    }
    
    public struct Temperature: Codable, Hashable, Comparable {
        public let celsiusValue: Double
        public var localizedValue: String {
            let formatter = MeasurementFormatter()
            formatter.unitStyle = .short
            formatter.unitOptions = .temperatureWithoutUnit
            return formatter.string(from: Measurement(value: celsiusValue, unit: UnitTemperature.celsius))
        }
        
        public init(celsius: Double) {
            self.celsiusValue = celsius
        }
        
        public init(fahrenheit: Double) {
            self.celsiusValue = (fahrenheit - 32) * 5/9
        }
        
        public static func < (lhs: Weather.Temperature, rhs: Weather.Temperature) -> Bool {
            return lhs.celsiusValue < rhs.celsiusValue
        }
    }
    
    public static func < (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.temperature < rhs.temperature
    }
}

public extension Array where Element == Weather {
    func sorted(distanceTo location: Location) -> [Weather] {
        return sorted { (w1, w2) -> Bool in
            let d1 = w1.location.distance(to: location)
            let d2 = w2.location.distance(to: location)
            return d1 < d2
        }
    }
}
