//
//  GustavGetBankAccountsRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class GustavGetBankAccountsRequestTests: GustavRequestTests {

    // swiftlint:disable force_unwrapping
    private let mockedBankAccounts: [BankAccount] = [
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

    var sut: GustavGetBankAccountsRequest!

    override func setUp() {
        super.setUp()

        sut = GustavGetBankAccountsRequest(baseURL: baseURL)
    }

    func test_makeHTTPRequest_ReturnsProperHTTPRequest() {
        guard let url =
            URL(string: "https://api.csas.cz/sandbox/webapi/api/v3/netbanking/my/accounts") else {
                XCTFail("Creating URL should not fail")
                return
        }

        let bankingRequest = GetBankAccountRequest(bankId: "csas")
        let result = sut.makeHTTPRequest(from: bankingRequest)

        XCTAssertEqual(result.encoding, .urlEncoding)
        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url, url)
    }

    func test_ParseResponse_ParsesResponseCorrectly() {
        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "GustavGetBankAccountsRequestResponse", withExtension: "json") else {
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

            XCTAssertEqual(result, mockedBankAccounts)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}
