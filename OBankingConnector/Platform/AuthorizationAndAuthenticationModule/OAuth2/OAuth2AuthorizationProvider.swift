//
//  OAuth2AuthorizationProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

protocol OAuth2AuthorizationProvider: AuthorizationProvider {
}

final class DefaultOAuth2AuthorizationProvider: OAuth2AuthorizationProvider {

    private let oAuth2BankServiceConfiguration: OAuth2BankServiceConfiguration
    private let oAuth2AuthorizationRequestFactory: OAuth2AuthorizationRequestFactory
    private let oAuth2AuthorizationRequestProcessor: OAuth2AuthorizationRequestProcessor

    init(
        oAuth2BankServiceConfiguration: OAuth2BankServiceConfiguration,
        oAuth2AuthorizationRequestFactory: OAuth2AuthorizationRequestFactory,
        oAuth2AuthorizationRequestProcessor: OAuth2AuthorizationRequestProcessor
    ) {
        self.oAuth2BankServiceConfiguration = oAuth2BankServiceConfiguration
        self.oAuth2AuthorizationRequestFactory = oAuth2AuthorizationRequestFactory
        self.oAuth2AuthorizationRequestProcessor = oAuth2AuthorizationRequestProcessor
    }

    func authorize() -> Single<AuthorizationResult> {
        let request = oAuth2AuthorizationRequestFactory.makeAuthorizationRequest(
            for: oAuth2BankServiceConfiguration
        )

        return oAuth2AuthorizationRequestProcessor.process(request)
    }
}
