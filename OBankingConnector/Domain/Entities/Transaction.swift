//
//  Transaction.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct Transaction {

    public let id: String
    public let bankId: String
    public let bankAccountId: String
    public let partyAccount: AccountNumber
    public let partyAccountHolderInformation: AccountHolderInformation
    public let amount: Amount
    public let text: String
    public let bookingDate: Date
    public let processingDate: Date?
    public let textType: TransactionTextType
    public let notes: String?
    public let exchangeRateInformation: ExchangeRateInformation?

    public init(id: String,
                bankId: String,
                bankAccountId: String,
                partyAccount: AccountNumber,
                partyAccountHolderInformation: AccountHolderInformation,
                amount: Amount,
                text: String,
                bookingDate: Date,
                processingDate: Date? = nil,
                textType: TransactionTextType = .unknown,
                notes: String? = nil,
                exchangeRateInformation: ExchangeRateInformation? = nil) {
        self.id = id
        self.bankId = bankId
        self.bankAccountId = bankAccountId
        self.partyAccount = partyAccount
        self.partyAccountHolderInformation = partyAccountHolderInformation
        self.amount = amount
        self.text = text
        self.bookingDate = bookingDate
        self.processingDate = processingDate
        self.textType = textType
        self.notes = notes
        self.exchangeRateInformation = exchangeRateInformation
    }
}
