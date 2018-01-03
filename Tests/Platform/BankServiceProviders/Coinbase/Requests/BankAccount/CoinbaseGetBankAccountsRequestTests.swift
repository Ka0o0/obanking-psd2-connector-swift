//
//  CoinbaseGetBankAccountsRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class CoinbaseGetBankAccountsRequestTests: CoinbaseRequestTests {

    var apiResponseMockData: Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "CoinbaseGetBankAccountsRequestResponse", withExtension: "json") else {
            return nil
        }

        return (try? String(contentsOf: apiResponseURL))?.data(using: .utf8)
    }

    var sut: CoinbaseGetBankAccountsRequest!
    var webClient: WebClientMock!

    override func setUp() {
        super.setUp()

        sut = CoinbaseGetBankAccountsRequest(baseURL: baseURL, certificate: Data())
        webClient = WebClientMock()
    }

    func test_MakeHTTPRequest_ReturnsProperHTTPRequest() {
        let bankingRequest = GetBankAccountRequest(bankId: "")

        guard let apiResponseMockData = self.apiResponseMockData else {
            XCTFail("Could not read GetBankAccountsRequestResponse")
            return
        }
        webClient.responseData = apiResponseMockData

        do {
            let result = try sut.perform(request: bankingRequest, using: webClient)
                .toBlocking(timeout: 3)
                .single()

            assertProperRequest()
            XCTAssertEqual(result.count, 1)
            XCTAssertEqual(result.map { $0.id }, [
                "8dad5865-5ab6-571b-9032-bfc5376c5eee"
            ])
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
        XCTAssertEqual(result.url.absoluteString, "https://api.coinbase.com/v2/accounts")
    }

}
