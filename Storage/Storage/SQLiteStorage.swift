//
//  SQLiteStorage.swift
//  Storage
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import SQLite
import Models
import Combine

public class SQLiteStorage: Storage {
    
    private let connection: AnyPublisher<Connection, StorageError>
    
    public init(_ location: Connection.Location) {
        self.connection = createConnection(location)
            .flatMap { createSchema(at: $0) }
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .eraseToAnyPublisher()
    }
    
    public func write(_ weathers: [Weather]) -> AnyPublisher<[Weather], StorageError> {
        return connection
            .tryMap { db in
                do {
                    try weathers.forEach { weather in
                        try db.run(weathersTable.insert(
                            or: .replace,
                            cityExpr <- weather.city,
                            countryExpr <- weather.country,
                            skyExpr <- weather.sky,
                            temperatureExpr <- weather.temperature.celsiusValue,
                            latitudeExpr <- weather.location.latitude,
                            longitudeExpr <- weather.location.longitude))
                        }
                } catch {
                    throw StorageError.insertion(error)
                }
            return weathers
        }
        .mapError { $0 as? StorageError ?? .unknown($0) }
        .eraseToAnyPublisher()
    }
    
    public func read() -> AnyPublisher<[Weather], StorageError> {
         return connection
                   .tryMap { db in
                       do {
                           return try db.prepare(weathersTable).map { row -> Weather in
                                Weather(city: row[cityExpr],
                                        country: row[countryExpr],
                                        location: .init(latitude: row[latitudeExpr], longitude: row[longitudeExpr]),
                                        temperature: .init(celsius: row[temperatureExpr]),
                                        sky: row[skyExpr])
                           }
                       } catch {
                           throw StorageError.selection(error)
                       }
                   }
                   .mapError { $0 as? StorageError ?? .unknown($0) }
                   .eraseToAnyPublisher()
    }
}

fileprivate let weathersTable = Table("weather")
fileprivate let cityExpr = Expression<String>("city")
fileprivate let countryExpr = Expression<String>("country")
fileprivate let skyExpr = Expression<String>("sky")
fileprivate let temperatureExpr = Expression<Double>("temperature")
fileprivate let latitudeExpr = Expression<Double>("latitude")
fileprivate let longitudeExpr = Expression<Double>("longitude")

fileprivate func createSchema(at connection: Connection) -> AnyPublisher<Connection, StorageError> {
    
    do {
        try connection.run(weathersTable.create(ifNotExists: true) { builder in
            builder.column(cityExpr)
            builder.column(countryExpr)
            builder.column(skyExpr)
            builder.column(temperatureExpr)
            builder.column(latitudeExpr)
            builder.column(longitudeExpr)
            builder.primaryKey(latitudeExpr, longitudeExpr)
        })
    } catch {
        return Swift.Result<Connection, StorageError>.failure(StorageError.tableCreation(error))
            .publisher
            .eraseToAnyPublisher()
    }
    
    return Swift.Result<Connection, StorageError>.success(connection)
        .publisher
        .eraseToAnyPublisher()
}

fileprivate func createConnection(_ location: Connection.Location) -> AnyPublisher<Connection, StorageError> {
    do {
        return Swift.Result<Connection, StorageError>.success(try Connection(location))
            .publisher
            .eraseToAnyPublisher()
    } catch {
        return Swift.Result<Connection, StorageError>.failure(StorageError.connectionCreation(error))
            .publisher
            .eraseToAnyPublisher()
    }
}
