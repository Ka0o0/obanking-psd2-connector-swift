//
//  CoinbaseBalance.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

struct CoinbaseBalance: Codable {

    let amount: String
    let currency: Currency

    func toAmount() throws -> Amount {
        let splitAmount = amount.split(separator: ".").map { String($0) }

        guard let significandString = splitAmount.first,
            let significand = Int(significandString, radix: 10) else {
            throw CoinbaseBalanceError.invalidAmount
        }
        let decimalNumberString: String? = splitAmount.count == 2 ? splitAmount[1] : nil
        var decimalNumber = 0

        if let decimalNumberString = decimalNumberString {
            decimalNumber = Int(decimalNumberString, radix: 10) ?? 0
        }

        let precision: Int = decimalNumberString?.count ?? 0

        return Amount(
            value: significand * Int(pow(Double(10), Double(precision))) + decimalNumber,
            precision: precision,
            currency: currency
        )
    }
}

enum CoinbaseBalanceError: Error {
    case invalidAmount
}
