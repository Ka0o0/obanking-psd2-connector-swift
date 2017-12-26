//
//  GustavGetTransactionHistoryRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class GustavGetTransactionHistoryRequestTests: GustavRequestTests {

    // swiftlint:disable line_length
    var url: URL! =
        URL(string: "https://api.csas.cz/sandbox/webapi/api/v3/netbanking/cz/my/accounts/CZ6508000000003766862329/transactions")
    // swiftlint:enable: line_length

    var sut: GustavGetTransactionHistoryRequest!

    override func setUp() {
        super.setUp()

        sut = GustavGetTransactionHistoryRequest(baseURL: baseURL)
    }

    func test_makeHTTPRequest_ReturnsProperHTTPRequest() {
        let bankingRequest = GetTransactionHistoryRequest(bankAccount: bankAccountMock)

        guard let result = try? sut.makeHTTPRequest(from: bankingRequest) else {
            XCTFail("Should not fail")
            return
        }

        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url, url)
    }

    func test_ParseResponse_ParsesResponseCorrectly() {
        let bankingRequest = GetTransactionHistoryRequest(bankAccount: bankAccountMock)

        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "GetTransactionHistoryRequestResponse", withExtension: "json") else {
            XCTFail("Could not read GetBankAccountsRequestResponse")
            return
        }

        do {
            let apiResponseMock = try String(contentsOf: apiResponseURL)
            guard let apiResponseMockData = apiResponseMock.data(using: .utf8) else {
                XCTFail("Could not create data from string")
                return
            }

            let result = try sut.parseResponse(of: bankingRequest, response: apiResponseMockData)

            XCTAssertEqual(result.transactions.count, 1)
            if let first = result.transactions.first {
                XCTAssertEqual(first.id, "I141126DXHZ3T")
            }
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}
