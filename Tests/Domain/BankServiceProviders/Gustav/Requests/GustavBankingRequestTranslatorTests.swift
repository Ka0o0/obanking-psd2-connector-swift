//
//  GustavBankingRequestTranslatorTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 24.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

// swiftlint:disable function_body_length
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

    func test_ParseResponse_ParsesGetBankAccountsRequestResponseCorrectly() {
        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "GetBankAccountsRequestResponse", withExtension: "json") else {
            XCTFail("Could not read GetBankAccountsRequestResponse")
            return
        }

        do {
            let apiResponseMock = try String(contentsOf: apiResponseURL)
            guard let apiResponseMockData = apiResponseMock.data(using: .utf8) else {
                XCTFail("Could not create data from string")
                return
            }

            // swiftlint:disable force_unwrapping
            let expectedResult: [BankAccount] = [
                BankAccount(
                    bankId: "csas",
                    id: "D2C8C1DCC51A3738538A40A4863CA288E0225E52",
                    accountNumber: SepaAccountNumber(iban: "CZ0708000000001019382023", bic: "GIBACZPX")!,
                    details: BankAccountDetails(
                        balance: Amount(value: 8965200, precision: 2, currency: .CZK),
                        type: .current,
                        disposeableBalance: Amount(value: 0, precision: 2, currency: .EUR),
                        alias: "moj osobny ucet s kasickou"
                    )
                ),
                BankAccount(
                    bankId: "csas",
                    id: "0D64CBB8815E231A4F7C846342FAFAC5C7D7FBA0",
                    accountNumber: SepaAccountNumber(iban: "CZ2708000000001825498223", bic: "GIBACZPX")!,
                    details: BankAccountDetails(
                        balance: Amount(value: 6200000, precision: 2, currency: .CZK),
                        type: .saving,
                        disposeableBalance: Amount(value: 0, precision: 2, currency: .EUR),
                        alias: "moje sporenie"
                    )
                ),
                BankAccount(
                    bankId: "csas",
                    id: "86EE795A6D92D963E9AA47E092BEFA2BEEEC3239",
                    accountNumber: SepaAccountNumber(iban: "CZ6508000000003766862329", bic: "GIBACZPX")!,
                    details: BankAccountDetails(
                        balance: Amount(value: 8000000, precision: 2, currency: .CZK),
                        type: .loan,
                        disposeableBalance: Amount(value: 0, precision: 2, currency: .EUR),
                        alias: "moj uver"
                    )
                )
            ]
            // swiftlint:enable force_unwrapping

            let result = try sut.parseResponse(of: GetBankAccountRequest(bankId: ""), response: apiResponseMockData)

            XCTAssertEqual(result, expectedResult)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

}
// swiftlint:enable function_body_length
