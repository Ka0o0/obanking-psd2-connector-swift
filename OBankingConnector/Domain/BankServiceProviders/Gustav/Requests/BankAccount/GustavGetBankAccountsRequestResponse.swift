//
//  GustavGetBankAccountsRequestResponse.swift
//  OBankingConnector
//
//  Created by Kai Takac on 25.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavGetBankAccountsRequestResponse: Codable {

    enum AccountType: String, Codable {
        case current = "CURRENT"
        case saving = "SAVING"
        case loan = "LOAN"
    }

    class Accountno: Codable {

        // swiftlint:disable nesting
        private enum CodingKeys: String, CodingKey {
            case iban = "cz-iban"
            case bic = "cz-bic"
        }
        // swiftlint:enable nesting

        let iban: String
        let bic: String
    }

    class Balance: Codable {
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

    class Account: Codable {
        let id: String
        let accountno: GustavGetBankAccountsRequestResponse.Accountno
        let alias: String?
        let balance: GustavGetBankAccountsRequestResponse.Balance
        let disposable: GustavGetBankAccountsRequestResponse.Balance?
        let type: GustavGetBankAccountsRequestResponse.AccountType
        let subtype: String
    }

    let accounts: [Account]
}
