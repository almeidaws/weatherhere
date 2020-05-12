//
//  LocalWeatherViewModel.swift
//  UserInterface
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import Combine
import Models
import Storage
import Networking
import GPS
import Services

class LocalWeatherViewModel: Publisher {
    typealias Output = Weather
    typealias Failure = LocalWeatherViewModelError
    
    private let publisher = PassthroughSubject<Weather, LocalWeatherViewModelError>()
    private var cancellables = Set<AnyCancellable>()
    private let gps: GPS = Services.make(for: GPS.self)
    private let storage: Storage = Services.make(for: Storage.self)
    private let networking: Requester = Services.make(for: Requester.self)
    
    func startRetrievingWeather() {
        gps
            .publisher
            .mapError { error in LocalWeatherViewModelError.gps(error) }
            .flatMap { location in self.networking
                .weather(at: location, .pt_br)
                .mapError { error in LocalWeatherViewModelError.networking(error) }
                .eraseToAnyPublisher()
            }.flatMap { weather in self.storage
                .write([weather])
                .mapError { error in LocalWeatherViewModelError.storage(error) }
                .eraseToAnyPublisher()
            }
            .compactMap { weathers in weathers.first }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.publisher.send(completion: .failure(error))
                case .finished:
                    self.publisher.send(completion: .finished)
                }
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
    
    func receive<S>(subscriber: S) where S : Subscriber, LocalWeatherViewModelError == S.Failure, Weather == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}

enum LocalWeatherViewModelError: Error, CustomStringConvertible {
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
