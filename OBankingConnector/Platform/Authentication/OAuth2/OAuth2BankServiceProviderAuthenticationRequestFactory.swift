//
//  ConfigurationBankServiceProviderAuthenticationRequestFactory.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class OAuth2BankServiceProviderAuthenticationRequestFactory: BankServiceProviderAuthenticationRequestFactory {

    private let configuration: OAuth2BankServiceConfiguration

    init(configuration: OAuth2BankServiceConfiguration) {
        self.configuration = configuration
    }

    func makeBankServiceProviderAuthenticationRequest() -> BankServiceProviderAuthenticationRequest {
        return OAuth2BankServiceProviderAuthenticationRequest(
            authorizationEndpointURL: configuration.authorizationEndpointURL,
            clientId: configuration.clientId,
            clientSecret: configuration.clientSecret,
            tokenEndpointURL: configuration.tokenEndpointURL,
            redirectURI: configuration.redirectURI,
            scope: configuration.scope,
            additionalAuthorizationRequestParameters: configuration.additionalAuthorizationRequestParameters,
            additionalTokenRequestParameters: configuration.additionalTokenRequestParameters
        )
    }
}
