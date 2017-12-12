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

    init(authorizationEndpointURL: URL,
         clientId: String,
         clientSecret: String? = nil,
         tokenEndpointURL: URL? = nil,
         redirectURI: String? = nil) {
        self.authorizationEndpointURL = authorizationEndpointURL
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.tokenEndpointURL = tokenEndpointURL
        self.redirectURI = redirectURI
    }
}
