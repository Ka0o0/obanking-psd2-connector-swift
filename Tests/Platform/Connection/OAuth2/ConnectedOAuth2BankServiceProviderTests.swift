//
//  ConnectedOAuth2BankServiceProviderTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 17.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class ConnectedOAuth2BankServiceProviderTests: XCTestCase {

    var webClient: WebClientMock!

    override func setUp() {
        super.setUp()

        webClient = WebClientMock()
    }

    func test_Perform_PerformsProperRequest() {
        let oAuth2ConnectionInformation = OAuth2BankServiceConnectionInformation(
            bankServiceProviderId: "test",
            accessToken: "asdf",
            tokenType: "bearer"
        )

        let httpBankingRequestFactory = HTTPBankingRequestFactoryMock()

        let sut = ConnectedOAuth2BankServiceProvider(
            oAuth2ConnectionInformation: oAuth2ConnectionInformation,
            httpBankingRequestFactory: httpBankingRequestFactory,
            webClient: webClient
        )

    }
}

private extension ConnectedOAuth2BankServiceProviderTests {

    class HTTPBankingRequestFactoryMock: HTTPBankingRequestFactory {

        var nextRequest: HTTPRequest?

        func makeHTTPRequest<T: BankingRequest>(
            for bankingRequest: T,
            bankServiceProvider: BankServiceProvider
        ) -> HTTPRequest? {
            return nextRequest
        }
    }
}
