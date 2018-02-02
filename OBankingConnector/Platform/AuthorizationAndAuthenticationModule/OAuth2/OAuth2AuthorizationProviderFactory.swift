//
//  OAuth2BankServiceProviderAuthorizationProcessorFactory.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

protocol OAuth2AuthorizationProviderFactory {
    func makeOAuth2BankServiceProviderAuthorizationProcessor(
        for configuration: OAuth2BankServiceConfiguration
    ) -> OAuth2AuthorizationProvider
}

// swiftlint:disable colon
final class DefaultOAuth2AuthorizationProviderFactory
    : OAuth2AuthorizationProviderFactory {

    private let oAuth2AuthorizationRequestFactory: OAuth2AuthorizationRequestFactory
    private let oAuth2AuthorizationRequestProcessor: OAuth2AuthorizationRequestProcessor

    init(
        oAuth2AuthorizationRequestFactory: OAuth2AuthorizationRequestFactory,
        oAuth2AuthorizationRequestProcessor: OAuth2AuthorizationRequestProcessor
    ) {
        self.oAuth2AuthorizationRequestFactory = oAuth2AuthorizationRequestFactory
        self.oAuth2AuthorizationRequestProcessor = oAuth2AuthorizationRequestProcessor
    }

    func makeOAuth2BankServiceProviderAuthorizationProcessor(
        for configuration: OAuth2BankServiceConfiguration
    ) -> OAuth2AuthorizationProvider {
        return DefaultOAuth2AuthorizationProvider(
            oAuth2BankServiceConfiguration: configuration,
            oAuth2AuthorizationRequestFactory: oAuth2AuthorizationRequestFactory,
            oAuth2AuthorizationRequestProcessor: oAuth2AuthorizationRequestProcessor
        )
    }
}
// swiftlint:enable colon
