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
    var webClient: WebClientMock!
    var apiResponseMockData: Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "GetBankAccountDetailsRequestResponse", withExtension: "json") else {
            return nil
        }

        guard let apiResponseMock = try? String(contentsOf: apiResponseURL),
            let apiResponseMockData = apiResponseMock.data(using: .utf8) else {
            return nil
        }

        return apiResponseMockData
    }

    override func setUp() {
        super.setUp()

        sut = GustavGetBankAccountDetailsRequest(baseURL: baseURL, certificate: Data())
        webClient = WebClientMock()
    }

    func test_performRequest() {
        let bankingRequest = GetBankAccountDetailsRequest(bankAccount: bankAccountMock)

        guard let apiResponseMockData = self.apiResponseMockData else {
            XCTFail("Could not create data from string")
            return
        }
        webClient.responseData = apiResponseMockData

        do {
            let result = try sut.perform(request: bankingRequest, using: webClient)
                .toBlocking(timeout: 3)
                .single()

            assertCreatesCorrectRequest()
            assertParsesResponseCorrectly(result)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    private func assertCreatesCorrectRequest() {
        guard let url =
            URL(string: "https://api.csas.cz/sandbox/webapi/api/v3/netbanking/my/accounts") else {
                XCTFail("Creating URL should not fail")
                return
        }

        guard let lastRequest = webClient.lastRequest else {
            XCTFail("A request should have been made")
            return
        }
        XCTAssertEqual(lastRequest.encoding, .urlEncoding)
        XCTAssertEqual(lastRequest.method, .get)
        XCTAssertEqual(lastRequest.url, url.appendingPathComponent(bankAccountMock.id))
    }

    private func assertParsesResponseCorrectly(_ result: BankAccountDetails) {
        let expectedResult = BankAccountDetails(
            balance: Amount(value: 8965200, precision: 2, currency: .CZK),
            type: .current,
            disposeableBalance: Amount(value: 0, precision: 2, currency: .EUR),
            alias: "moj osobny ucet s kasickou"
        )

        XCTAssertEqual(result.balance, expectedResult.balance)
        XCTAssertEqual(result.type, expectedResult.type)
        XCTAssertEqual(result.disposeableBalance, expectedResult.disposeableBalance)
        XCTAssertEqual(result.alias, expectedResult.alias)
    }
}
