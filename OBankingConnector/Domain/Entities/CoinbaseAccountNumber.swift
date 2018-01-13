//
//  CoinbaseAccountNumber.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

public struct CoinbaseAccountNumber: AccountNumber, Codable {

    public let id: String

    public init(id: String) {
        self.id = id
    }

    public func equals(other: AccountNumber) -> Bool {
        guard let otherCoinbaseAccountNumber = other as? CoinbaseAccountNumber else {
            return false
        }

        return otherCoinbaseAccountNumber.id == self.id
    }
}
