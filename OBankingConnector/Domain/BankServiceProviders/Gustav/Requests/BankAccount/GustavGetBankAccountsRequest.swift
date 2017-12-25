//
//  GustavGetBankAccountsRequest.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 23.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavGetBankAccountsRequest {

    private var url: URL

    init(baseURL: URL) {
        url = baseURL.appendingPathComponent("netbanking/my/accounts")
    }

    func makeHTTPRequest(pageSize: Int? = nil, page: Int? = nil) -> HTTPRequest {
        var parameters = [String: String]()

        if let pageSize = pageSize {
            parameters["size"] = String(pageSize)
        }

        if let page = page {
            parameters["page"] = String(page)
        }

        return HTTPRequest(
            method: .get,
            url: url,
            parameters: parameters,
            encoding: .urlEncoding,
            headers: nil
        )
    }

    func parseResponse(_ response: Data) throws -> [BankAccount] {
        let jsonDecoder = JSONDecoder()
        let apiResponse = try jsonDecoder.decode(GustavGetBankAccountsRequestResponse.self, from: response)

        var bankAccounts = [BankAccount]()

        try apiResponse.accounts.forEach { apiAccount in
            let bankAccountType: BankAccountType

            switch apiAccount.type {
            case .current:
                bankAccountType = .current
            case .saving:
                bankAccountType = .saving
            case .loan:
                bankAccountType = .loan
            }

            let balance = try apiAccount.balance.toAmount()
            let disposeableBalance = try apiAccount.disposable?.toAmount()

            let bankAccountDetails = BankAccountDetails(
                balance: balance,
                type: bankAccountType,
                disposeableBalance: disposeableBalance,
                alias: apiAccount.alias
            )

            guard let accountNumber = SepaAccountNumber(
                iban: apiAccount.accountno.iban,
                bic: apiAccount.accountno.bic
            ) else {
                throw GustavGetBankAccountsRequestParseError.invalidSepaAccountNumber
            }

            let bankAccount = BankAccount(
                bankId: "csas",
                id: apiAccount.id,
                accountNumber: accountNumber,
                details: bankAccountDetails
            )

            bankAccounts.append(bankAccount)
        }

        return bankAccounts
    }
}

enum GustavGetBankAccountsRequestParseError: Error {
    case unknownCurrency
    case unknownAccountType
    case invalidSepaAccountNumber
}

private class GustavGetBankAccountsRequestResponse: Codable {

    fileprivate enum AccountType: String, Codable {
        case current = "CURRENT"
        case saving = "SAVING"
        case loan = "LOAN"
    }

    fileprivate class Accountno: Codable {

        // swiftlint:disable nesting
        private enum CodingKeys: String, CodingKey {
            case iban = "cz-iban"
            case bic = "cz-bic"
        }
        // swiftlint:enable nesting

        let iban: String
        let bic: String
    }

    fileprivate class Balance: Codable {
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

    fileprivate class Account: Codable {
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
