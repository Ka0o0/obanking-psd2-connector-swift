//
//  CryptoCurrencyAccountNumber.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

public struct CryptoCurrencyAccountNumber: AccountNumber {

    public let address: String
    public let network: String

    init(address: String, network: String) {
        self.address = address
        self.network = network
    }

    public func equals(other: AccountNumber) -> Bool {
        guard let otherCryptoAddress = other as? CryptoCurrencyAccountNumber else {
            return false
        }

        return otherCryptoAddress.address == self.address
    }
}
