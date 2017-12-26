//
//  GustavAccount.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct GustavAccount: Codable {

    let id: String
    let accountno: GustavAccountno
    let alias: String?
    let balance: GustavBalance
    let disposable: GustavBalance?
    let type: GustavAccountType
    let subtype: String

    func toBankAccount() throws -> BankAccount {
        let bankAccountType: BankAccountType

        switch type {
        case .current:
            bankAccountType = .current
        case .saving:
            bankAccountType = .saving
        case .loan:
            bankAccountType = .loan
        }

        let balance = try self.balance.toAmount()
        let disposeableBalance = try disposable?.toAmount()

        let bankAccountDetails = BankAccountDetails(
            balance: balance,
            type: bankAccountType,
            disposeableBalance: disposeableBalance,
            alias: alias
        )

        guard let accountNumber = SepaAccountNumber(
            iban: accountno.iban,
            bic: accountno.bic
        ) else {
            throw GustavGetBankAccountsRequestParseError.invalidSepaAccountNumber
        }

        return BankAccount(
            bankId: "csas",
            id: id,
            accountNumber: accountNumber,
            details: bankAccountDetails
        )
    }
}
