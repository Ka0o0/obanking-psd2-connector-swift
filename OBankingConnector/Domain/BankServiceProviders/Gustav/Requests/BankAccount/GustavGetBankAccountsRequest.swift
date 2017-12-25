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
