//
//  ConfigurationBankServiceProviderAuthenticationRequestFactoryProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
final class ConfigurationBankServiceProviderAuthenticationRequestFactoryProvider: BankServiceProviderAuthenticationRequestFactoryProvider {
    // swiftlint:enable line_length

    private let configurationParser: ConfigurationParser

    init(configurationParser: ConfigurationParser) {
        self.configurationParser = configurationParser
    }

    func makeAuthenticationRequestFactory(for bankServiceProvider: BankServiceProvider)
        -> BankServiceProviderAuthenticationRequestFactory? {

        guard let configuration = configurationParser.getBankServiceConfiguration(for: bankServiceProvider) else {
            return nil
        }

        if let oAuth2Configuration = configuration as? OAuth2BankServiceConfiguration {
            return OAuth2BankServiceProviderAuthenticationRequestFactory(configuration: oAuth2Configuration)
        }

        return nil
    }
}
