//
//  OAuth2AuthorizationRequestURLBuilderMock.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
@testable import OBankingConnector

final class OAuth2AuthorizationRequestURLBuilderMock: OAuth2AuthorizationRequestURLBuilder {

    var shouldSucceed = true
    let requestURL: URL

    var lastRequest: OAuth2AuthorizationRequest?
    var lastState: UUID?

    init() {
        var requestURLString = "https://authorization-server.com/auth"
        requestURLString += "?response_type=code"
        requestURLString += "&client_id=example"
        requestURLString += "&client_secret=secret"
        requestURLString += "&redirect_uri=myapp://handleme"
        requestURLString += "&scope=create+delete"

        guard let requestURL = URL(string: requestURLString) else {
            fatalError()
        }

        self.requestURL = requestURL
    }

    func makeAuthorizationCodeRequestURL(
        for request: OAuth2AuthorizationRequest,
        adding state: UUID?
    ) -> URL? {
        lastRequest = request
        lastState = state

        guard shouldSucceed else {
            return nil
        }

        return requestURL
    }
}
