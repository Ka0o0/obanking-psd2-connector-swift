//
//  ConfigurationParser.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class ConfigurationParser {

    private let configuration: OBankingConnectorConfiguration

    init(configuration: OBankingConnectorConfiguration) {
        self.configuration = configuration
    }

    func getBankServiceConfiguration(for bankService: BankServiceProvider)
        -> BankServiceProviderConfiguration? {

        let result = configuration.bankServiceProviderConfigurations.filter {
            $0.bankServiceProviderId == bankService.id
        }
        return result.first
    }
}
