//
//  BankAccountTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class BankAccountDetailsTests: XCTestCase {

    func test_Init_TakesRequired() {
        let mockedBalance = Amount(value: 1000, precision: 2, currency: .EUR)
        let accountType = BankAccountType.current
        let sut = BankAccountDetails(
            balance: mockedBalance,
            type: accountType,
            disposeableBalance: nil,
            alias: nil
        )

        XCTAssertEqual(sut.type, accountType)
        XCTAssertNil(sut.disposeableBalance)
        XCTAssertNil(sut.alias)
    }
}
