//
//  ConfigurationEnabledSupportedBankServicesProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 17.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class ConfigurationEnabledSupportedBankServicesProvider: SupportedBankServicesProvider {

    let supportedBankServices: [BankServiceProvider]

    private let systemWideBankServiceProviders: [BankServiceProvider] = [
        GustavBankServiceProvider(),
        CoinbaseBankServiceProvider()
    ]

    init(configuration: OBankingConnectorConfiguration) {
        let configuredBankServices = systemWideBankServiceProviders.filter { bankServiceProvider -> Bool in
            let configurationsForBankService = configuration.bankServiceProviderConfigurations.filter {
                $0.bankServiceProvider.id == bankServiceProvider.id
            }
            return !configurationsForBankService.isEmpty
        }

        self.supportedBankServices = configuredBankServices
    }

    func bankService(for id: String) -> BankServiceProvider? {
        return supportedBankServices.filter { $0.id == id }.first
    }
}
