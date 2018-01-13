//
//  GetDateFilteredTransactionHistoryRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct GetDateFilteredTransactionHistoryRequest: BankingRequest {

    public typealias Result = TransactionHistory

    public let bankAccount: BankAccount
    public let startDate: Date
    public let endDate: Date

    public init(
        bankAccount: BankAccount,
        startDate: Date,
        endDate: Date
    ) {
        self.bankAccount = bankAccount
        self.startDate = startDate
        self.endDate = endDate
    }
}
