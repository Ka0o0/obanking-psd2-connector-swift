//
//  GustavTransaction.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct GustavTransaction: Codable {

    struct AccountParty: Codable {
        let iban: String
        let bic: String
        let partyInfo: String
        let partyDescription: String
    }

    let id: String
    let accountParty: AccountParty
    let amount: GustavBalance
    let amountSender: GustavBalance
    let bookingDate: Date
    let valuationDate: Date
    let payerNote: String
    let payeeNote: String
    let description: String?

    func toTransaction(associating bankAccount: BankAccount) throws -> Transaction {

        guard let partyAccount = SepaAccountNumber(iban: accountParty.iban, bic: accountParty.bic) else {
            throw GustavTransactionConversionError.invalidAccountNumber
        }
        let accountHolderInformation = AccountHolderInformation(fullName: accountParty.partyInfo)

        let amount = try self.amount.toAmount()
        let amountSender = try self.amountSender.toAmount()

        var exchangeRateInformation: ExchangeRateInformation?
        if amountSender.currency != amount.currency {
            exchangeRateInformation = ExchangeRateInformation(
                source: amountSender.currency,
                target: amount.currency,
                rate: amount.toDecimal() / amountSender.toDecimal(),
                date: valuationDate
            )
        }

        return Transaction(
            id: id,
            bankId: "csas",
            bankAccountId: bankAccount.id,
            partyAccount: partyAccount,
            partyAccountHolderInformation: accountHolderInformation,
            amount: amount.value > 0 ? amount : amountSender,
            text: payerNote,
            bookingDate: bookingDate,
            processingDate: valuationDate,
            textType: .unknown,
            notes: description,
            exchangeRateInformation: exchangeRateInformation
        )
    }
}

enum GustavTransactionConversionError: Error {
    case invalidAccountNumber
}
