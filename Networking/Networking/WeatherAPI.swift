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
        let sys: Sys
        
        struct Sys: Decodable, Hashable {
            let country: String
        }
        
        struct Coord: Decodable, Hashable {
            let lat: Double
            let lon: Double
        }
        
        struct Main: Decodable, Hashable {
            let temp: Double
        }
        
        struct Weather: Decodable, Hashable {
            let description: String
        }
    }
    
    struct FindResponse: Decodable, Hashable {
        let list: [ListItem]
        
        struct ListItem: Decodable, Hashable {
            let name: String
            let main: Main
            let weather: [Weather]
            let coord: Coord
            let sys: Sys
            
            struct Sys: Decodable, Hashable {
                let country: String
            }
            
            struct Coord: Decodable, Hashable {
                let lat: Double
                let lon: Double
            }
            
            struct Weather: Decodable, Hashable {
                let description: String
            }
            
            struct Main: Decodable, Hashable {
                let temp: Double
            }
        }
    }
    
    public enum Language: String {
        case en
        case pt_br
    }
}

extension Requester {
    public func weather(at location: Location, _ languageIdentifier: String, _ bundle: Bundle = .main) -> AnyPublisher<Weather, RequestError> {
        let parameters = [
            "appid": Endpoint.apiKey(bundle),
            "lat": "\(location.latitude)",
            "lon": "\(location.longitude)",
            "lang": languageIdentifier
        ]
        return get(from: .weather(bundle), queryParameters: parameters, decoder: JSONDecoder())
            .map { (decodedResponse: RequestDecodedResponse<WeatherAPI.WeatherResponse>) -> Weather in
                let sky = decodedResponse.data.weather.first?.description ?? "Unknown"
                return Weather(
                    city: decodedResponse.data.name,
                    country: decodedResponse.data.sys.country,
                    location: .init(latitude: decodedResponse.data.coord.lat, longitude: decodedResponse.data.coord.lon),
                    temperature: .init(kelvin: decodedResponse.data.main.temp),
                    sky: sky)
            }.eraseToAnyPublisher()
    }
    
    public func weatherNearby(at location: Location, maxPlaces: Int = 20, _ languageIdentifier: String, _ bundle: Bundle = .main) -> AnyPublisher<[Weather], RequestError> {
        let parameters = [
            "appid": Endpoint.apiKey(bundle),
            "lat": "\(location.latitude)",
            "lon": "\(location.longitude)",
            "cnt": "\(maxPlaces)",
            "lang": languageIdentifier
        ]
        return get(from: .weatherNearby(bundle), queryParameters: parameters, decoder: JSONDecoder())
            .map { (decodedResponse: RequestDecodedResponse<WeatherAPI.FindResponse>) -> [Weather] in
                return decodedResponse.data.list.map { item in
                    let sky = item.weather.first?.description ?? "Unknown"
                    return Weather(
                        city: item.name,
                        country: item.sys.country,
                        location: .init(latitude: item.coord.lat, longitude: item.coord.lon),
                        temperature: Weather.Temperature(kelvin: item.main.temp),
                        sky: sky)
                }
                
        }.map { (weathers) -> [Weather] in weathers.sorted(distanceTo: location) }
        .eraseToAnyPublisher()
    }
}
