//
//  GustavGetBankAccountDetailsRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class GustavGetBankAccountDetailsRequestTests: GustavRequestTests {

    var sut: GustavGetBankAccountDetailsRequest!

    override func setUp() {
        super.setUp()

        sut = GustavGetBankAccountDetailsRequest(baseURL: baseURL)
    }

    func test_makeHTTPRequest_ReturnsProperHTTPRequest() {
        guard let url =
            URL(string: "https://api.csas.cz/sandbox/webapi/api/v3/netbanking/my/accounts") else {
            XCTFail("Creating URL should not fail")
            return
        }

        let bankingRequest = GetBankAccountDetailsRequest(bankAccount: bankAccountMock)

        let result = sut.makeHTTPRequest(from: bankingRequest)

        XCTAssertEqual(result.encoding, .urlEncoding)
        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url, url.appendingPathComponent(bankAccountMock.id))
    }

    func test_ParseResponse_ParsesResponseCorrectly() {
        let bankingRequest = GetBankAccountDetailsRequest(bankAccount: bankAccountMock)

        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "GustavGetBankAccountDetailsRequestResponse", withExtension: "json") else {
            XCTFail("Could not read GetBankAccountsRequestResponse")
            return
        }

        do {
            let apiResponseMock = try String(contentsOf: apiResponseURL)
            guard let apiResponseMockData = apiResponseMock.data(using: .utf8) else {
                XCTFail("Could not create data from string")
                return
            }

            let expectedResult = BankAccountDetails(
                balance: Amount(value: 8965200, precision: 2, currency: .CZK),
                type: .current,
                disposeableBalance: Amount(value: 0, precision: 2, currency: .EUR),
                alias: "moj osobny ucet s kasickou"
            )

            let result = try sut.parseResponse(of: bankingRequest, response: apiResponseMockData)

            XCTAssertEqual(result.balance, expectedResult.balance)
            XCTAssertEqual(result.type, expectedResult.type)
            XCTAssertEqual(result.disposeableBalance, expectedResult.disposeableBalance)
            XCTAssertEqual(result.alias, expectedResult.alias)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}
