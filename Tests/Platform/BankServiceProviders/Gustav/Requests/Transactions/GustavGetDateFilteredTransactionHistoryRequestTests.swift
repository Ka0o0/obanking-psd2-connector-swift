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

    var webClient: WebClientMock!
    var sut: GustavGetDateFilteredTransactionHistoryRequest!

    var bankingRequest: GetDateFilteredTransactionHistoryRequest {
        let startDate = Date(timeIntervalSince1970: 1401580800) // 2014-06-01T00:00:00+00:00
        let endDate = Date(timeIntervalSince1970: 1404172800) // 2014-07-01T00:00:00+00:00
        return GetDateFilteredTransactionHistoryRequest(
            bankAccount: bankAccountMock,
            startDate: startDate,
            endDate: endDate
        )
    }

    var apiResponseMockData: Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "GustavGetTransactionHistoryRequestResponse", withExtension: "json") else {
            return nil
        }

        return (try? String(contentsOf: apiResponseURL))?.data(using: .utf8)
    }

    override func setUp() {
        super.setUp()

        sut = GustavGetDateFilteredTransactionHistoryRequest(baseURL: baseURL, certificate: Data())
        webClient = WebClientMock()
    }

    func test_PerformRequest() {
        guard let apiResponseMockData = self.apiResponseMockData else {
            XCTFail("Could not create data from string")
            return
        }
        webClient.responseData = apiResponseMockData

        do {
            let result = try sut.perform(request: bankingRequest, using: webClient)
                .toBlocking(timeout: 3)
                .single()

            assertProperRequest()

            XCTAssertEqual(result.transactions.count, 1)
            if let first = result.transactions.first {
                XCTAssertEqual(first.id, "I141126DXHZ3T")
            }
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    private func assertProperRequest() {
        guard let result = webClient.lastRequest else {
            XCTFail("No request")
            return
        }

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
}
