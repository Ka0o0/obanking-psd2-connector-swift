//
//  OAuth2BankServiceProviderAuthenticationRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct OAuth2BankServiceProviderAuthenticationRequest: BankServiceProviderAuthenticationRequest {

    let authorizationEndpointURL: URL
    let clientId: String
    let clientSecret: String?
    let tokenEndpointURL: URL?
    let redirectURI: String?
    let scope: String?
    let additionalAuthorizationRequestParameters: [String: String]?
    let additionalTokenRequestParameters: [String: String]?

    init(authorizationEndpointURL: URL,
         clientId: String,
         clientSecret: String? = nil,
         tokenEndpointURL: URL? = nil,
         redirectURI: String? = nil,
         scope: String? = nil,
         additionalAuthorizationRequestParameters: [String: String]? = nil,
         additionalTokenRequestParameters: [String: String]? = nil) {
        self.authorizationEndpointURL = authorizationEndpointURL
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.tokenEndpointURL = tokenEndpointURL
        self.redirectURI = redirectURI
        self.scope = scope
        self.additionalAuthorizationRequestParameters = additionalAuthorizationRequestParameters
        self.additionalTokenRequestParameters = additionalTokenRequestParameters
    }
}
