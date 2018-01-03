//
//  CoinbaseGetBankAccountDetailsRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class CoinbaseGetBankAccountDetailsRequestTests: CoinbaseRequestTests {

    var apiResponseMockData: Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "CoinbaseGetBankAccountDetailsRequestResponse", withExtension: "json") else {
            return nil
        }

        return (try? String(contentsOf: apiResponseURL))?.data(using: .utf8)
    }

    var sut: CoinbaseGetBankAccountDetailsRequest!
    var webClient: WebClientMock!

    override func setUp() {
        super.setUp()

        sut = CoinbaseGetBankAccountDetailsRequest(baseURL: baseURL, certificate: Data())
        webClient = WebClientMock()
    }

    func test_MakeHTTPRequest_ReturnsProperHTTPRequest() {
        let bankingRequest = GetBankAccountDetailsRequest(
            bankAccount: BankAccount(
                bankId: "coinbase",
                id: "asdf",
                accountNumber: CoinbaseAccountNumber(id: "testaccount")
            )
        )

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

            XCTAssertEqual(result.alias, "My Wallet")
            XCTAssertEqual(result.type, .current)
            XCTAssertEqual(result.balance, Amount(value: 3959000000, precision: 8, currency: .BTC))
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
        XCTAssertEqual(result.url.absoluteString, "https://api.coinbase.com/v2/accounts/asdf")
    }

}
