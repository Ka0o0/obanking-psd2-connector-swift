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

    var apiResponseMockData: Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let apiResponseURL = testBundle
            .url(forResource: "GetBankAccountsRequestResponse", withExtension: "json") else {
            return nil
        }

        guard let apiResponseMock = try? String(contentsOf: apiResponseURL),
            let apiResponseMockData = apiResponseMock.data(using: .utf8) else {
            return nil
        }

        return apiResponseMockData
    }

    var webClient: WebClientMock!
    var sut: GustavGetBankAccountsRequest!

    override func setUp() {
        super.setUp()

        sut = GustavGetBankAccountsRequest(baseURL: baseURL, certificate: Data())
        webClient = WebClientMock()
    }

    func test_makeHTTPRequest_ReturnsProperHTTPRequest() {
        let bankingRequest = GetBankAccountRequest(bankId: "csas")

        guard let apiResponseMockData = self.apiResponseMockData else {
            XCTFail("Could not create data from string")
            return
        }
        webClient.responseData = apiResponseMockData

        do {
            let result = try sut.perform(request: bankingRequest, using: webClient).toBlocking(timeout: 3).single()

            assertProperRequest()
            XCTAssertEqual(result, mockedBankAccounts)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    private func assertProperRequest() {
        guard let result = webClient.lastRequest else {
            XCTFail("No request")
            return
        }

        guard let url =
            URL(string: "https://api.csas.cz/sandbox/webapi/api/v3/netbanking/my/accounts") else {
            XCTFail("Creating URL should not fail")
            return
        }

        XCTAssertEqual(result.encoding, .urlEncoding)
        XCTAssertEqual(result.method, .get)
        XCTAssertEqual(result.url, url)
    }
}
