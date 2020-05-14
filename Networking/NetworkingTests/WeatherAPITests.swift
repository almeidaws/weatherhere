//
//  WeatherAPITests.swift
//  NetworkingTests
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import XCTest
import Models
import Combine
import Services
@testable import Networking

fileprivate let location = Location(latitude: -15.805034, longitude: -48.021302)
fileprivate let liveWeather = Weather(city: "Brasília", country: "BR", location: .init(latitude: -15.81, longitude:  -48.02), temperature: .init(kelvin: 294.15), sky: "clear sky")
fileprivate let findWeathers = [
    Weather(city: "Brasilia", country: "BR", location: .init(latitude: -15.78, longitude: -47.93), temperature: .init(kelvin: 293.15), sky: "clear sky"),
    Weather(city: "Guará", country: "BR", location: .init(latitude: -15.83, longitude: -47.9), temperature: .init(kelvin: 293.15), sky: "clear sky"),
    Weather(city: "Gama", country: "BR", location: .init(latitude: -15.95, longitude: -48.08), temperature: .init(kelvin: 293.15), sky: "clear sky"),
    ].sorted(distanceTo: location)

class WeatherAPITests: XCTestCase {
    
    func testSupportedCurrenciesSuccessfulResponse() {
        let bundle = Bundle(identifier: "com.almeidaws.WeatherHere.NetworkingTests")!
        let fileURL = bundle.url(forResource: "live_successful", withExtension: "txt")!
        let data = try! Data(contentsOf: fileURL)
        Services.default.register(Requester.self) { MockedRequester(mock: .success(RequestResponse(data: data, status: .ok, request: URLRequest(url: fileURL)))) }
        let requester: Requester = Services.make(for: Requester.self)
        
        let expectation = self.expectation(description: "Wait response")
        _ = requester.weather(at: location, "en", bundle).sink(receiveCompletion: { completion in }) { weather in
            assert(liveWeather == weather, "Read weather aren't equal to the expected.")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 0.1)
    }
    
    func testRealTimeQuotesSuccessfulResponse() {
        let bundle = Bundle(identifier: "com.almeidaws.WeatherHere.NetworkingTests")!
        let fileURL = bundle.url(forResource: "find_successful", withExtension: "txt")!
        let data = try! Data(contentsOf: fileURL)
        Services.default.register(Requester.self) { MockedRequester(mock: .success(RequestResponse(data: data, status: .ok, request: URLRequest(url: fileURL)))) }
        let requester: Requester = Services.make(for: Requester.self)
        
        let expectation = self.expectation(description: "Wait response")
        _ = requester.weatherNearby(at: location, "en", bundle).sink(receiveCompletion: { completion in }) { weathers in
            assert(findWeathers == weathers, "Read weathers aren't equal to the expected.")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 0.1)
    }
    
}
