//
//  BankAccountTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class BankAccountTests: XCTestCase {

    func test_Init_TakesRequired() {
        let mockedAccountNumber = AccountNumberMock(identifier: "Test")
        let mockedBalance = Amount(value: 1000, precision: 2, currency: .EUR)
        let accountType = BankAccountType.current
        let sut = BankAccount(
            id: "example_account",
            accountNumber: mockedAccountNumber,
            balance: mockedBalance,
            type: accountType,
            disposeableBalance: nil,
            alias: nil
        )

        XCTAssertEqual(sut.id, "example_account")
        XCTAssertTrue(sut.accountNumber.equals(other: mockedAccountNumber))
        XCTAssertEqual(sut.type, accountType)
        XCTAssertNil(sut.disposeableBalance)
        XCTAssertNil(sut.alias)
    }
}
