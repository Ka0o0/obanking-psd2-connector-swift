//
//  TransactionHistory.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct TransactionHistory {

    public let date: Date
    public let transactions: [Transaction]

    public init(date: Date, transactions: [Transaction]) {
        self.date = date
        self.transactions = transactions
    }
}
