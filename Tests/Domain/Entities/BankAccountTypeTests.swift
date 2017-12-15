//
//  BankAccountTypeTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class BankAccountTypeTests: XCTestCase {

    func test_Current_Exists() {
        _ = BankAccountType.current
    }

    func test_Saving_Exists() {
        _ = BankAccountType.saving
    }

    func test_Loan_Exists() {
        _ = BankAccountType.loan
    }
}
