//
//  BankAccount.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct BankAccount {

    public let bankId: String
    public let id: String
    public let accountNumber: AccountNumber
    public let details: BankAccountDetails?

    public init(
        bankId: String,
        id: String,
        accountNumber: AccountNumber,
        details: BankAccountDetails? = nil
    ) {
        self.bankId = bankId
        self.id = id
        self.accountNumber = accountNumber
        self.details = details
    }
}
