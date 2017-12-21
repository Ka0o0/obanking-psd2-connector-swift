//
//  ConfigurationHTTPBankingRequestFactory.swift
//  OBankingConnector
//
//  Created by Kai Takac on 17.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

protocol HTTPBankingRequestFactory {

    func makeHTTPRequest<T: BankingRequest>(
        for bankingRequest: T,
        bankServiceProvider: BankServiceProvider
    ) -> HTTPRequest?
}

final class ConfigurationHTTPBankingRequestFactory: HTTPBankingRequestFactory {

    private let configurationParser: ConfigurationParser

    init(configurationParser: ConfigurationParser) {
        self.configurationParser = configurationParser
    }

    func makeHTTPRequest<T: BankingRequest>(
        for bankingRequest: T,
        bankServiceProvider: BankServiceProvider
    ) -> HTTPRequest? {
        guard let configuration = configurationParser.getBankServiceConfiguration(for: bankServiceProvider) else {
            return nil
        }

        guard let oAuthConfiguration = configuration as? OAuth2BankServiceConfiguration else {
            return nil
        }

        return oAuthConfiguration.bankingRequestTranslator.makeHTTPRequest(from: bankingRequest)
    }
}
