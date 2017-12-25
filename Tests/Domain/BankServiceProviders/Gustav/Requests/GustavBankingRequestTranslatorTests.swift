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

    var baseURL: URL! = URL(string: "https://api.csas.cz/sandbox/webapi/api/v3")
    var getBankAccountsRequestURL: URL! =
        URL(string: "https://api.csas.cz/sandbox/webapi/api/v3/netbanking/my/accounts")

    var sut: GustavBankingRequestTranslator!

    override func setUp() {
        super.setUp()

        sut = GustavBankingRequestTranslator(baseURL: baseURL)
    }

    func test_makeHTTPRequest_SupportsGetBankAccountsRequest() {
        let bankingRequest = GetBankAccountRequest(bankId: "")

        guard let result = sut.makeHTTPRequest(from: bankingRequest) else {
            XCTFail("Request must not be nil")
            return
        }

        XCTAssertEqual(result.encoding, .urlEncoding)
        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url, getBankAccountsRequestURL)
    }

    func test_makeHTTPRequest_SupportsPaginatedGetBankAccountsRequest() {
        let bankingRequest = PaginatedBankingRequest(
            page: 1,
            itemsPerPage: 20,
            request: GetBankAccountRequest(bankId: "")
        )

        guard let result = sut.makeHTTPRequest(from: bankingRequest) else {
            XCTFail("Request must not be nil")
            return
        }

        XCTAssertEqual(result.encoding, .urlEncoding)
        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url, getBankAccountsRequestURL)

        guard let parameters = result.parameters as? [String: String] else {
            XCTFail("Parameters should not be nil")
            return
        }
        let expectedParameters: [String: String] = ["page": "1", "size": "20"]
        XCTAssertEqual(parameters, expectedParameters)
    }

}
