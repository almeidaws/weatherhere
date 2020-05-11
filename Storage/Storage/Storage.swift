//
//  Storage.swift
//  Storage
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

import Foundation
import Combine
import Models

public protocol Storage {
    func write(_ weathers: [Weather]) -> AnyPublisher<[Weather], StorageError>
    func read() -> AnyPublisher<[Weather], StorageError>
}

public enum StorageError: Error, CustomStringConvertible {
    case connectionCreation(Error)
    case tableCreation(Error)
    case insertion(Error)
    case selection(Error)
    case unknown(Error)
    
    public var description: String {
        switch self {
        case .connectionCreation(let error): return "Connection creation: \(error)"
        case .tableCreation(let error): return "Table creation: \(error)"
        case .insertion(let error): return "Insertion: \(error)"
        case .selection(let error): return "Selection: \(error)"
        case .unknown(let error): return "Unknown: \(error)"
        }
    }
}
