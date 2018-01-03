//
//  CoinbaseBankServiceProvider.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

public struct CoinbaseBankServiceProvider: BankServiceProvider {

    public static let id = "com.coinbase.api.wallet.v2"

    public let id: String
    public let name: String
    public let supportedBanks: [Bank] = [
        Bank(id: "com.coinbase", name: "Coinbase", bankServiceProviderId: CoinbaseBankServiceProvider.id)
    ]

    public init() {
        self.id = CoinbaseBankServiceProvider.id
        self.name = "Coinbase Wallet API v2"
    }
}
