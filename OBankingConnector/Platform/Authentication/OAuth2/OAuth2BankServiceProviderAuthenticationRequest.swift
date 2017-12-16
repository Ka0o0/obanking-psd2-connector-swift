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
    let additionalRequestHeaders: [String: String]?

    init(authorizationEndpointURL: URL,
         clientId: String,
         clientSecret: String?,
         tokenEndpointURL: URL?,
         redirectURI: String?,
         scope: String?,
         additionalAuthorizationRequestParameters: [String: String]?,
         additionalTokenRequestParameters: [String: String]?,
         additionalRequestHeaders: [String: String]?) {
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
