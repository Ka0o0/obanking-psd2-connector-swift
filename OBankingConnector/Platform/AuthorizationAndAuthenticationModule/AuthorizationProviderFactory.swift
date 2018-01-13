//
//  AuthorizationProviderFactory.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

protocol AuthorizationProviderFactory {
    func makeAuthorizationProcessor(for configuration: BankServiceProviderConfiguration)
        -> AuthorizationProvider?
}

final class DefaultAuthorizationProviderFactory: AuthorizationProviderFactory {

    private let oAuth2AuthorizationProcessorFactory: OAuth2AuthorizationProviderFactory
    init(
        oAuth2AuthorizationProcessorFactory: OAuth2AuthorizationProviderFactory
    ) {
        self.oAuth2AuthorizationProcessorFactory = oAuth2AuthorizationProcessorFactory
    }

    func makeAuthorizationProcessor(for configuration: BankServiceProviderConfiguration)
        -> AuthorizationProvider? {

        if let oAuth2Configuration = configuration  as? OAuth2BankServiceConfiguration {
            return oAuth2AuthorizationProcessorFactory.makeOAuth2BankServiceProviderAuthorizationProcessor(
                for: oAuth2Configuration
            )
        }
        return nil
    }
}
