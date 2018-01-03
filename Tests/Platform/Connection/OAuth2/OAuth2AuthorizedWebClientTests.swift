//
//  OAuth2AuthorizedWebClientTests.swift
//  OBankingConnectorTests-iOS
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class OAuth2AuthorizedWebClientTests: XCTestCase {

    func test_Request_AddsAuthorizationHeader() {
        let connectionInformation = OAuth2BankServiceConnectionInformation(
            bankServiceProviderId: "",
            accessToken: "test",
            tokenType: "othertype"
        )
        let webClient = WebClientMock()
        webClient.responseData = Data()

        let sut = OAuth2AuthorizedWebClient(
            oAuth2ConnectionInformation: connectionInformation,
            webClient: webClient
        )

        let url = URL(fileURLWithPath: "example")

        do {
            _ = try sut.request(
                .get,
                url,
                parameters: nil,
                encoding: .urlEncoding,
                headers: nil,
                certificate: Data()
            ).toBlocking(timeout: 3).first()

            guard let lastRequest = webClient.lastRequest else {
                XCTFail("Should have performed a request")
                return
            }

            guard let headers = lastRequest.headers else {
                XCTFail("Should have set headers")
                return
            }

            XCTAssertEqual(headers, ["Authorization": "othertype test"])
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

}
