//
//  Endpoint.swift
//  Networking
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

fileprivate let BASE_URL_KEY = "BASE_URL_KEY"
fileprivate let API_KEY = "API_KEY"

enum Endpoint {
    fileprivate static func baseURL(_ bundle: Bundle = .main) -> URL {
        guard let basePath = bundle.object(forInfoDictionaryKey: BASE_URL_KEY) else {
            fatalError("There's no value for key '\(BASE_URL_KEY)' in Info.plist file.")
        }
        guard let basePathStr = basePath as? String else {
            fatalError("The value for key '\(basePath)' isn't a string.")
        }
        guard let baseURL = URL(string: basePathStr) else {
            fatalError("The base URL '\(basePathStr)' isn't really a valid URL.")
        }
        return baseURL
    }
    
    static func apiKey(_ bundle: Bundle = .main) -> String {
        guard let apiPath = bundle.object(forInfoDictionaryKey: API_KEY) else {
           fatalError("There's no value for key '\(API_KEY)' in Info.plist file.")
       }
       guard let apiStr = apiPath as? String else {
           fatalError("The value for key '\(apiPath)' isn't a string.")
       }
        return apiStr
    }
}

extension Endpoint {
    static func weather(_ bundle: Bundle = .main) -> URL {
        return baseURL(bundle).appendingPathComponent("weather")
    }
    
    static func weatherNearby(_ bundle: Bundle = .main) -> URL {
        return baseURL(bundle).appendingPathComponent("find")
    }
}

extension URL {
    static func weather(_ bundle: Bundle = .main) -> URL {
        return Endpoint.baseURL(bundle).appendingPathComponent("weather")
    }
    
    static func weatherNearby(_ bundle: Bundle = .main) -> URL {
        return Endpoint.baseURL(bundle).appendingPathComponent("find")
    }
}

