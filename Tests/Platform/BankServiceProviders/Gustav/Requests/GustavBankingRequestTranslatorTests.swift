//
//  GustavBankingRequestTranslatorTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 24.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class GustavBankingRequestTranslatorTests: XCTestCase {

    let bankAccount = BankAccount(bankId: "", id: "", accountNumber: AccountNumberMock(identifier: ""))
    var sut: GustavBankingRequestTranslator!

    override func setUp() {
        super.setUp()

        sut = GustavBankingRequestTranslator(baseURL: URL(fileURLWithPath: "test"), certificate: Data())
    }

    func test_makeProcessor_GetBankAccountRequest() {
        let result = sut.makeProcessor(for: GetBankAccountRequest(bankId: ""))
        XCTAssertTrue(result is GustavGetBankAccountsRequest)
    }

    func test_makeProcessor_GetBankAccountDetailsRequest() {
        let result = sut.makeProcessor(for: GetBankAccountDetailsRequest(bankAccount: bankAccount))
        XCTAssertTrue(result is GustavGetBankAccountDetailsRequest)
    }

    func test_makeProcessor_GetTransactionHistoryRequest() {
        let result = sut.makeProcessor(for: GetTransactionHistoryRequest(bankAccount: bankAccount))
        XCTAssertTrue(result is GustavGetTransactionHistoryRequest)
    }

    func test_makeProcessor_GetDateFilteredTransactionHistoryRequest() {
        let result = sut.makeProcessor(
            for: GetDateFilteredTransactionHistoryRequest(
                bankAccount: bankAccount,
                startDate: Date(),
                endDate: Date()
            )
        )
        XCTAssertTrue(result is GustavGetDateFilteredTransactionHistoryRequest)
    }

    func test_makeProcessor_GetPaginatedBankAccountRequest() {
        let result = sut.makeProcessor(
            for: PaginatedBankingRequest(
                page: 0,
                itemsPerPage: 0,
                request: GetBankAccountRequest(bankId: "")
            )
        )
        XCTAssertTrue(result is GustavPaginatedRequestProcessor<GetBankAccountRequest>)
    }

    func test_makeProcessor_GetPaginatedTransactionHistoryRequest() {
        let result = sut.makeProcessor(
            for: PaginatedBankingRequest(
                page: 0,
                itemsPerPage: 0,
                request: GetTransactionHistoryRequest(bankAccount: bankAccount)
            )
        )
        XCTAssertTrue(result is GustavPaginatedRequestProcessor<GetTransactionHistoryRequest>)
    }

    func test_makeProcessor_GetPaginatedDateFilteredTransactionHistoryRequest() {
        let result = sut.makeProcessor(
            for: PaginatedBankingRequest(
                page: 0,
                itemsPerPage: 0,
                request: GetDateFilteredTransactionHistoryRequest(
                    bankAccount: bankAccount,
                    startDate: Date(),
                    endDate: Date()
                )
            )
        )
        XCTAssertTrue(result is GustavPaginatedRequestProcessor<GetDateFilteredTransactionHistoryRequest>)
    }
}
