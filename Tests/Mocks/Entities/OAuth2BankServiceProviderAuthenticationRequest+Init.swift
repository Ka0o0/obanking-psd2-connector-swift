//
//  OAuth2BankServiceProviderAuthenticationRequest+Init.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
@testable import OBankingConnector

extension OAuth2BankServiceProviderAuthenticationRequest {

    init(
        bankingServiceProviderId: String,
        authorizationEndpointURL: URL,
        clientId: String,
        clientSecret: String? = nil,
        tokenEndpointURL: URL? = nil,
        redirectURI: String? = nil,
        scope: String? = nil,
        additionalAuthorizationRequestParameters: [String: String]? = nil,
        additionalTokenRequestParameters: [String: String]? = nil,
        additionalRequestHeaders: [String: String]? = nil
    ) {
        self.bankingServiceProviderId = bankingServiceProviderId
        self.authorizationEndpointURL = authorizationEndpointURL
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.tokenEndpointURL = tokenEndpointURL
        self.redirectURI = redirectURI
        self.scope = scope
        self.additionalAuthorizationRequestParameters = additionalAuthorizationRequestParameters
        self.additionalTokenRequestParameters = additionalTokenRequestParameters
        self.additionalRequestHeaders = additionalRequestHeaders
    }
}
