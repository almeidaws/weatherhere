//
//  Weather.swift
//  Models
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

public struct Weather: Codable, Hashable, Comparable {
    public let city: String
    public let country: String
    public let location: Location
    public let temperature: Temperature
    public let sky: String
    
    public init(city: String, country: String, location: Location, temperature: Temperature, sky: String) {
        self.city = city
        self.country = country
        self.location = location
        self.temperature = temperature
        self.sky = sky
    }
    
    public struct Temperature: Codable, Hashable, Comparable {
        public var feelsLike: FeelsLike {
            switch celsiusValue {
            case ..<16: return .cold
            case ..<24: return .cool
            default: return .hot
            }
        }
        public let celsiusValue: Double
        public var localizedValue: String {
            let formatter = MeasurementFormatter()
            formatter.unitStyle = .short
            formatter.unitOptions = .naturalScale
            formatter.locale = .current
            return formatter.string(from: Measurement(value: celsiusValue, unit: UnitTemperature.celsius))
        }
        
        public init(celsius: Double) {
            self.celsiusValue = celsius
        }
        
        public init(kelvin: Double) {
            self.celsiusValue = kelvin - 273.15
        }
        
        public static func < (lhs: Weather.Temperature, rhs: Weather.Temperature) -> Bool {
            return lhs.celsiusValue < rhs.celsiusValue
        }
        
        public enum FeelsLike: Int, Codable, Hashable, Comparable {
            case hot
            case cool
            case cold
            
            public static func < (lhs: Weather.Temperature.FeelsLike, rhs: Weather.Temperature.FeelsLike) -> Bool {
                return lhs.rawValue < rhs.rawValue
            }
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
