//
//  DefaultAuthorizationModule.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultAuthorizationModule: AuthorizationModule {

    private let authorizationProcessorFactory: AuthorizationProviderFactory
    private let configurationParser: ConfigurationParser

    init(
        authorizationProcessorFactory: AuthorizationProviderFactory,
        configurationParser: ConfigurationParser
    ) {
        self.authorizationProcessorFactory = authorizationProcessorFactory
        self.configurationParser = configurationParser
    }

    func authorize(against bankServiceProvider: BankServiceProvider)
        -> Single<AuthorizationResult> {

        guard let configuration = configurationParser.getBankServiceConfiguration(
            for: bankServiceProvider
        ) else {
            return Single.error(AuthorizationError.unsupportedBankServiceProvider)
        }

        guard let processor = authorizationProcessorFactory.makeAuthorizationProcessor(
            for: configuration
        ) else {
            return Single.error(AuthorizationError.noProperProcessorFound)
        }

        return processor.authorize()
    }
}
