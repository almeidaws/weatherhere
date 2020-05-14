//
//  GPS.swift
//  GPS
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import Combine
import Models

public protocol GPS {
    var publisher: PassthroughSubject<Location, GPSError> { get }
    func start()
    func stop()
}

public enum GPSError: Error, CustomStringConvertible {
    case internalError(Error)
    case unexpectedFutureAuthorizationStatus
    case unexpectedAuthorization(String)
    case disabledGlobally
    case authorizationDenied(SuggestedFlow)
    
    public var description: String {
        switch self {
        case .unexpectedAuthorization(let authorization):
            return "Unexpected authorization: \(authorization)"
        case .disabledGlobally:
            return "Location disabled globally"
        case .authorizationDenied(let suggestion):
            return "Authorization denied: \(suggestion)"
        case .unexpectedFutureAuthorizationStatus:
            return "Unexpected authorization status created after app's creation"
        case .internalError(let error):
            return "An internal error has happend: \(error)"
        }
    }
    
    public enum SuggestedFlow: CustomStringConvertible {
        case askAgain
        case authorizeManually(at: URL)
        case doNothing
        
        public var description: String {
            switch self {
            case .doNothing:
                return "There's nothing to do"
            case .askAgain:
                return "Ask authorization again"
            case .authorizeManually:
                return "Send the user to app's location settings"
            }
        }
    }
}
