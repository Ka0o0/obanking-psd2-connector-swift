//
//  DefaultBankServiceProviderAuthenticationProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultBankServiceProviderAuthenticationProvider: BankServiceProviderAuthenticationProvider {

    private let authorizationProcessorFactory: BankServiceProviderAuthorizationProcessorFactory
    private let configurationParser: ConfigurationParser

    init(
        authorizationProcessorFactory: BankServiceProviderAuthorizationProcessorFactory,
        configurationParser: ConfigurationParser
    ) {
        self.authorizationProcessorFactory = authorizationProcessorFactory
        self.configurationParser = configurationParser
    }

    func authenticate(against bankServiceProvider: BankServiceProvider)
        -> Single<BankServiceProviderAuthenticationResult> {

        guard let configuration = configurationParser.getBankServiceConfiguration(
            for: bankServiceProvider
        ) else {
            return Single.error(BankServiceProviderAuthenticationProviderError.unsupportedBankServiceProvider)
        }

        guard let processor = authorizationProcessorFactory.makeAuthorizationProcessor(
            for: configuration
        ) else {
            return Single.error(BankServiceProviderAuthenticationProviderError.noProperProcessorFound)
        }

        return processor.authorize()
    }
}
