//
//  DefaultOAuth2BankServiceProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

class DefaultOAuth2BankServiceProvider: OAuth2BankServiceProvider {

    let id: String
    let name: String
    let authorizationEndpointURL: URL
    let tokenEndpointURL: URL?
    let clientId: String
    let clientSecret: String?
    let redirectURI: String?

    init(id: String,
         name: String,
         authorizationEndpointURL: URL,
         tokenEndpointURL: URL?,
         clientId: String,
         clientSecret: String?,
         redirectURI: String?) {
        self.id = id
        self.name = name
        self.authorizationEndpointURL = authorizationEndpointURL
        self.tokenEndpointURL = tokenEndpointURL
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
}
