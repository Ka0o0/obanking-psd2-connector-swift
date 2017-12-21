//
//  HTTPRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 17.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct HTTPRequest {

    let method: HTTPMethod
    let url: URL
    let parameters: [String: Any]?
    let encoding: ParameterEncoding
    let headers: [String: String]?

    init(
        method: HTTPMethod,
        url: URL,
        parameters: [String: Any]?,
        encoding: ParameterEncoding,
        headers: [String: String]?
    ) {
        self.method = method
        self.url = url
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
}
