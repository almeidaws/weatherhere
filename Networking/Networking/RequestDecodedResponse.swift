
//
//  RequestDecodedResponse.swift
//  Networking
//
//  Created by Gustavo Amaral on 11/05/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

public struct RequestDecodedResponse<D: Decodable & Hashable>: Hashable {
    public let data: D
    public let status: HTTPStatusCode
    public let request: URLRequest
}
