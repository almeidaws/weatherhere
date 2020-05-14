//
//  NearbyWeatherViewModel.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 12/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import Storage
import Networking
import GPS
import Combine
import Services
import Models

class NearbyWeatherViewModel: Publisher {
    typealias Output = [Weather]
    typealias Failure = LocalWeatherViewModelError
    
    private var publisher = PassthroughSubject<[Weather], LocalWeatherViewModelError>()
    private var cancellables = Set<AnyCancellable>()
    private var gps: GPS = Services.make(for: GPS.self)
    private let storage: Storage = Services.make(for: Storage.self)
    private let networking: Requester = Services.make(for: Requester.self)
    
    func startRetrievingWeather() {
        let gpsPublisher = gps
            .publisher
            .mapError { error in LocalWeatherViewModelError.gps(error) }
        
        let readFromCachePublisher = gpsPublisher
        .flatMap { location in
            self.storage.read()
            .mapError { error in LocalWeatherViewModelError.storage(error) }
            .map { weathers in weathers.sorted(distanceTo: location) }
        }.eraseToAnyPublisher()
        
        let readFromInternetPublisher = gpsPublisher
            .flatMap { location in self.networking
                .weatherNearby(at: location, String(Locale.current.identifier.split(separator: "_")[0]))
                .mapError { error in LocalWeatherViewModelError.networking(error) }
                .eraseToAnyPublisher()
            }
            .flatMap { weather in self.storage
                .write(weather)
                .mapError { error in LocalWeatherViewModelError.storage(error) }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        readFromCachePublisher
            .merge(with: readFromInternetPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.publisher.send(completion: .failure(error))
                case .finished:
                    self.publisher.send(completion: .finished)
                }
                self.publisher = PassthroughSubject<[Weather], LocalWeatherViewModelError>()
                self.gps = Services.make(for: GPS.self)
            }) { weather in
                self.publisher.send(weather)
            }.store(in: &cancellables)
        gps.start()
    }
    
    func stopRetrievingWeather() {
        gps.stop()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, LocalWeatherViewModelError == S.Failure, [Weather] == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}

enum NearbyWeatherViewModelError: Error {
    case storage(StorageError)
    case networking(RequestError)
    case gps(GPSError)
    
    var description: String {
        switch self {
        case .storage(let error):
            return "Storage: \(error)"
        case .networking(let error):
            return "Networking: \(error)"
        case .gps(let error):
            return "GPS: \(error)"
        }
    }
}
