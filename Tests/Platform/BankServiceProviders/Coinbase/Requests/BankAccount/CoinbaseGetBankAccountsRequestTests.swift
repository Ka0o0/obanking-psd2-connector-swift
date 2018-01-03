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

    var sut: CoinbaseGetBankAccountsRequest!

    override func setUp() {
        super.setUp()

        sut = CoinbaseGetBankAccountsRequest(baseURL: baseURL)
    }

    func test_MakeHTTPRequest_ReturnsProperHTTPRequest() {
        let bankingRequest = GetBankAccountRequest(bankId: "")
        guard let result = try? sut.makeHTTPRequest(from: bankingRequest) else {
            XCTFail("Was not able to create request")
            return
        }

        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url.absoluteString, "https://api.coinbase.com/v2/accounts")
    }

    func test_ParseResponse_ParsesResponseCorrectly() {
        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "CoinbaseGetBankAccountsRequestResponse", withExtension: "json") else {
                XCTFail("Could not read GetBankAccountsRequestResponse")
                return
        }

        do {
            let apiResponseMock = try String(contentsOf: apiResponseURL)
            guard let apiResponseMockData = apiResponseMock.data(using: .utf8) else {
                XCTFail("Could not create data from string")
                return
            }

            let result = try sut.parseResponse(of: GetBankAccountRequest(bankId: ""), response: apiResponseMockData)

//            XCTAssertEqual(result, mockedBankAccounts)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}
