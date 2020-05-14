//
//  SQLiteStorage.swift
//  StorageTests
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import XCTest
import Models
import Combine
import Services
@testable import Storage

fileprivate let location = Location(latitude: -15.805034, longitude: -48.021302)
fileprivate let testWeathers = [
    Weather(city: "Brasilia", country: "BR", location: .init(latitude: -15.78, longitude: -47.93), temperature: .init(kelvin: 293.15), sky: "clear sky"),
    Weather(city: "Guará", country: "BR", location: .init(latitude: -15.83, longitude: -47.9), temperature: .init(kelvin: 293.15), sky: "clear sky"),
    Weather(city: "Gama", country: "BR", location: .init(latitude: -15.95, longitude: -48.08), temperature: .init(kelvin: 293.15), sky: "clear sky"),
    ].sorted(distanceTo: location)
extension SQLiteStorage: Service { }

class SQLiteStorageTests: XCTestCase {
    
    override func setUp() {
        Services.register(Storage.self) { SQLiteStorage(.inMemory) }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func testWritingAndReadingCurrenciesBack() {
        let storage: Storage = Services.default.make(for: Storage.self)
        let expectation = self.expectation(description: "Wait write and read")
        storage.write(testWeathers)
            .flatMap { currencies -> AnyPublisher<[Weather], StorageError> in storage.read() }
            .sink(receiveCompletion: { completion in
                print(completion)
            }) { weathers in
                print(self)
                XCTAssert(testWeathers == weathers.sorted(distanceTo: location), "Read weathers aren't equal to the written.")
                expectation.fulfill()
        }.store(in: &cancellables)
        
        self.wait(for: [expectation], timeout: 0.1)
    }
}
