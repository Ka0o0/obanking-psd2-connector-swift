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

    var apiResponseMockData: Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "GetTransactionHistoryRequestResponse", withExtension: "json") else {
            return nil
        }

        let apiResponseMock = try? String(contentsOf: apiResponseURL)
        return apiResponseMock?.data(using: .utf8)
    }

    var sut: GustavGetTransactionHistoryRequest!
    var webClient: WebClientMock!

    override func setUp() {
        super.setUp()

        sut = GustavGetTransactionHistoryRequest(baseURL: baseURL, certificate: Data())
        webClient = WebClientMock()
    }

    func test_PerformRequest() {
        let bankingRequest = GetTransactionHistoryRequest(bankAccount: bankAccountMock)

        guard let apiResponseMockData = self.apiResponseMockData else {
            XCTFail("Failed to read response mock")
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
            XCTFail("Not request was made")
            return
        }

        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url, url)
    }
}
