//
//  WeatherAPI.swift
//  Networking
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import Models
import Combine

public enum WeatherAPI {
    
    struct WeatherResponse: Decodable, Hashable {
        let weather: [Weather]
        let main: Main
        let name: String
        let coord: Coord
        
        struct Coord: Decodable, Hashable {
            let lat: Double
            let lon: Double
        }
        
        struct Main: Decodable, Hashable {
            let temp: Double
        }
        
        struct Weather: Decodable, Hashable {
            let main: String
        }
    }
    
    struct FindResponse: Decodable, Hashable {
        let list: [ListItem]
        
        struct ListItem: Decodable, Hashable {
            let name: String
            let main: Main
            let weather: [Weather]
            let coord: Coord
            
            struct Coord: Decodable, Hashable {
                let lat: Double
                let lon: Double
            }
            
            struct Weather: Decodable, Hashable {
                let main: String
            }
            
            struct Main: Decodable, Hashable {
                let temp: Double
            }
        }
    }
}

extension Requester {
    public func weather(at location: Location, _ bundle: Bundle = .main) -> AnyPublisher<Weather, RequestError> {
        let parameters = [
            "appid": Endpoint.apiKey(bundle),
            "lat": "\(location.latitude)",
            "lon": "\(location.longitude)"
        ]
        return get(from: .weather(bundle), queryParameters: parameters, decoder: JSONDecoder())
            .map { (decodedResponse: RequestDecodedResponse<WeatherAPI.WeatherResponse>) -> Weather in
                let sky = decodedResponse.data.weather.first?.main ?? "Unknown"
                return Weather(
                    place: decodedResponse.data.name,
                    location: .init(latitude: decodedResponse.data.coord.lat, longitude: decodedResponse.data.coord.lon),
                    temperature: .init(fahrenheit: decodedResponse.data.main.temp),
                    sky: sky)
            }.eraseToAnyPublisher()
    }
    
    public func weatherNearby(at location: Location, maxPlaces: Double = 20, _ bundle: Bundle = .main) -> AnyPublisher<[Weather], RequestError> {
        let parameters = [
            "appid": Endpoint.apiKey(bundle),
            "lat": "\(location.latitude)",
            "lon": "\(location.longitude)",
            "cnt": "\(maxPlaces)"
        ]
        return get(from: .weather(bundle), queryParameters: parameters, decoder: JSONDecoder())
            .map { (decodedResponse: RequestDecodedResponse<WeatherAPI.FindResponse>) -> [Weather] in
                return decodedResponse.data.list.map { item in
                    let sky = item.weather.first?.main ?? "Unknown"
                    return Weather(
                        place: item.name,
                        location: .init(latitude: item.coord.lat, longitude: item.coord.lon),
                        temperature: Weather.Temperature(fahrenheit: item.main.temp),
                        sky: sky)
                }
                
        }.map { (weathers) -> [Weather] in weathers.sorted(distanceTo: location) }
        .eraseToAnyPublisher()
    }
}
