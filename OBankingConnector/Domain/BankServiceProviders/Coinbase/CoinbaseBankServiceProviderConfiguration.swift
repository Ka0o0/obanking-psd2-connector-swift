//
//  CoinbaseBankServiceProviderConfiguration.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

public struct CoinbaseBankServiceProviderConfiguration: BankServiceProviderConfiguration {

    public let bankServiceProvider: BankServiceProvider = CoinbaseBankServiceProvider()

    let clientId: String
    let clientSecret: String?
    let redirectURI: String?
    let accessScope: CoinbaseAPIScope

    public init(
        clientId: String,
        clientSecret: String,
        redirectURI: String,
        accessScope: CoinbaseAPIScope
    ) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
        self.accessScope = accessScope
    }
}
