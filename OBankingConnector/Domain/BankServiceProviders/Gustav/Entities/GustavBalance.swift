//
//  GustavBalance.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct GustavBalance: Codable {
    let value: Int
    let precision: Int
    let currency: String

    func toAmount() throws -> Amount {
        guard let currency = Currency(rawValue: currency) else {
            throw GustavGetBankAccountsRequestParseError.unknownCurrency
        }

        return Amount(
            value: value,
            precision: precision,
            currency: currency
        )
    }
}
