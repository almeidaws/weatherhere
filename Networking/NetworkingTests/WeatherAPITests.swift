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
fileprivate let liveWeather = Weather(place: "Brasília", location: .init(latitude: -15.81, longitude:  -48.02), temperature: .init(fahrenheit: 294.15), sky: "Clear")
fileprivate let findWeathers = [
    Weather(place: "Brasilia", location: .init(latitude: -15.78, longitude: -47.93), temperature: .init(fahrenheit: 293.15), sky: "Clear"),
    Weather(place: "Guará", location: .init(latitude: -15.83, longitude: -47.9), temperature: .init(fahrenheit: 293.15), sky: "Clear"),
    Weather(place: "Gama", location: .init(latitude: -15.95, longitude: -48.08), temperature: .init(fahrenheit: 293.15), sky: "Clear"),
    ].sorted(distanceTo: location)

class WeatherAPITests: XCTestCase {
    
    func testSupportedCurrenciesSuccessfulResponse() {
        let bundle = Bundle(identifier: "com.almeidaws.WeatherHere.NetworkingTests")!
        let fileURL = bundle.url(forResource: "live_successful", withExtension: "txt")!
        let data = try! Data(contentsOf: fileURL)
        Services.default.register(Requester.self) { MockedRequester(mock: .success(RequestResponse(data: data, status: .ok, request: URLRequest(url: fileURL)))) }
        let requester: Requester = Services.make(for: Requester.self)
        
        let expectation = self.expectation(description: "Wait response")
        _ = requester.weather(at: location, bundle).sink(receiveCompletion: { completion in }) { weather in
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
        _ = requester.weatherNearby(at: location, bundle).sink(receiveCompletion: { completion in }) { weathers in
            assert(findWeathers == weathers, "Read weathers aren't equal to the expected.")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 0.1)
    }
    
}
