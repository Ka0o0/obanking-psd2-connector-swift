//
//  GetBankAccountRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct GetBankAccountRequest: BankingRequest {

    public typealias Result = [BankAccount]

    let bankId: String

    public init(bankId: String) {
        self.bankId = bankId
    }

    public init(bank: Bank) {
        self.init(bankId: bank.id)
    }
}
