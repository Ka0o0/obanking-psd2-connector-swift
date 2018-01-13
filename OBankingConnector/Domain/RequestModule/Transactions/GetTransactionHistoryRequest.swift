//
//  GetTransactionHistoryRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct GetTransactionHistoryRequest: BankingRequest {

    public typealias Result = TransactionHistory

    let bankAccount: BankAccount

    public init(bankAccount: BankAccount) {
        self.bankAccount = bankAccount
    }
}
