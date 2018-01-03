//
//  CoinbaseBankingRequestTranslatorTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class CoinbaseBankingRequestTranslatorTests: XCTestCase {

    let bankAccount = BankAccount(bankId: "", id: "", accountNumber: AccountNumberMock(identifier: ""))
    var sut: CoinbaseBankingRequestTranslator!

    override func setUp() {
        super.setUp()

        sut = CoinbaseBankingRequestTranslator(
            baseURL: URL(fileURLWithPath: "test"),
            certificate: Data()
        )
    }

    func test_makeProcessor_GetBankAccountRequest() {
        let result = sut.makeProcessor(for: GetBankAccountRequest(bankId: ""))
        XCTAssertTrue(result is CoinbaseGetBankAccountsRequest)
    }

    func test_makeProcessor_GetBankAccountDetailsRequest() {
        let result = sut.makeProcessor(for: GetBankAccountDetailsRequest(bankAccount: bankAccount))
        XCTAssertTrue(result is CoinbaseGetBankAccountDetailsRequest)
    }
}
