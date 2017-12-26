//
//  GustavGetDateFilteredTransactionHistoryRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class GustavGetDateFilteredTransactionHistoryRequestTests: GustavRequestTests {

    // swiftlint:disable line_length
    var url: URL! =
        URL(string: "https://api.csas.cz/sandbox/webapi/api/v3/netbanking/cz/my/accounts/CZ6508000000003766862329/transactions")
    // swiftlint:enable: line_length

    var sut: GustavGetDateFilteredTransactionHistoryRequest!

    override func setUp() {
        super.setUp()

        sut = GustavGetDateFilteredTransactionHistoryRequest(baseURL: baseURL)
    }

    func test_makeHTTPRequest_ReturnsProperHTTPRequest() {
        let startDate = Date(timeIntervalSince1970: 1401580800) // 2014-06-01T00:00:00+00:00
        let endDate = Date(timeIntervalSince1970: 1404172800) // 2014-07-01T00:00:00+00:00
        let bankingRequest = GetDateFilteredTransactionHistoryRequest(
            bankAccount: bankAccountMock,
            startDate: startDate,
            endDate: endDate
        )

        let result = sut.makeHTTPRequest(from: bankingRequest)

        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url, url)

        guard let parameters = result.parameters as? [String: String] else {
            XCTFail("Parameters should not be nil")
            return
        }
        let expectedParameters: [String: String] = [
            "dateStart": "2014-06-01T00:00:00.000Z",
            "dateEnd": "2014-07-01T00:00:00.000Z"
        ]
        XCTAssertEqual(parameters, expectedParameters)
    }

    func test_ParseResponse_ParsesResponseCorrectly() {
        let startDate = Date(timeIntervalSince1970: 1401580800) // 2014-06-01T00:00:00+00:00
        let endDate = Date(timeIntervalSince1970: 1404172800) // 2014-07-01T00:00:00+00:00
        let bankingRequest = GetDateFilteredTransactionHistoryRequest(
            bankAccount: bankAccountMock,
            startDate: startDate,
            endDate: endDate
        )

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
