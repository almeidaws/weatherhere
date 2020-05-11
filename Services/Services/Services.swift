//
//  Services.swift
//  Services
//
//  Created by Gustavo Amaral on 10/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

public protocol Service { }

public class Services {
    
    public static let `default` = Services()
    private var registers = [ObjectIdentifier : () -> Service]()
    
    public func register<S, I>(_ service: S.Type, maker: @escaping () -> I) where I: Service {
        registers[ObjectIdentifier(service)] = maker
    }
    
    public func make<S, I>(for service: S.Type) -> I where I: Service {
        let id = ObjectIdentifier(service)
        guard let maker = registers[id] else {
            fatalError("Service '\(service)' wasn't previously registered")
        }
        guard let casted = maker() as? I else {
            fatalError("Service '\(service)' can't be downcasted to '\(I.self)'.")
        }
        return casted
    }
}

public extension Services {
    static func register<S, I>(_ service: S.Type, maker: @escaping () -> I) where I: Service {
        Services.default.register(service, maker: maker)
    }
    
    static func make<S, I>(for service: S.Type) -> I where I: Service {
        return Services.default.make(for: service)
    }
}

