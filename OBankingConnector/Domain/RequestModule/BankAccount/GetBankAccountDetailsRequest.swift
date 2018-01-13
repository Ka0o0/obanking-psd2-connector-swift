//
//  GetBankAccountDetailsRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct GetBankAccountDetailsRequest: BankingRequest {

    public typealias Result = BankAccountDetails

    let bankAccount: BankAccount

    public init(bankAccount: BankAccount) {
        self.bankAccount = bankAccount
    }
}
