//
//  OAuth2AuthorizationRequestFactory.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

protocol OAuth2AuthorizationRequestFactory {
    func makeAuthorizationRequest(
        for configuration: OAuth2BankServiceConfiguration
    ) -> OAuth2AuthorizationRequest
}

final class DefaultOAuth2AuthorizationRequestFactory: OAuth2AuthorizationRequestFactory {

    func makeAuthorizationRequest(
        for configuration: OAuth2BankServiceConfiguration
    ) -> OAuth2AuthorizationRequest {
        return OAuth2AuthorizationRequest(
            bankingServiceProviderId: configuration.bankServiceProvider.id,
            authorizationEndpointURL: configuration.authorizationEndpointURL,
            clientId: configuration.clientId,
            clientSecret: configuration.clientSecret,
            tokenEndpointURL: configuration.tokenEndpointURL,
            redirectURI: configuration.redirectURI,
            scope: configuration.scope,
            additionalAuthorizationRequestParameters: configuration.additionalAuthorizationRequestParameters,
            additionalTokenRequestParameters: configuration.additionalTokenRequestParameters,
            additionalRequestHeaders: configuration.additionalHeaders,
            authorizationServerCertificate: configuration.authorizationServerCertificate,
            tokenServerCertificate: configuration.tokenServerCertificate
        )
    }
}
