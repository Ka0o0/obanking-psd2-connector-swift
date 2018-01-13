//
//  OBankingConnectorConfiguration.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct OBankingConnectorConfiguration {

    let bankServiceProviderConfigurations: [BankServiceProviderConfiguration]

    public init(
        bankServiceProviderConfigurations: [BankServiceProviderConfiguration]
    ) {
        self.bankServiceProviderConfigurations = bankServiceProviderConfigurations
    }
}
