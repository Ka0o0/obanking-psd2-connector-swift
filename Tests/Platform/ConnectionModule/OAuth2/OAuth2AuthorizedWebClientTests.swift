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
        let configuration = OAuth2BankServiceConfigurationMock()
        let webClient = WebClientMock()
        webClient.responseData = Data()

        let sut = OAuth2AuthorizedWebClient(
            oAuth2ConnectionInformation: connectionInformation,
            oAuth2BankServiceConfiguration: configuration,
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

            XCTAssertEqual(headers, [
                "Authorization": "Othertype test",
                "test": "test"
            ])
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

}

private extension OAuth2AuthorizedWebClientTests {
    class OAuth2BankServiceConfigurationMock: OAuth2BankServiceConfiguration {
        var authorizationEndpointURL: URL { fatalError() }

        var clientId: String { fatalError() }

        var clientSecret: String? { fatalError() }

        var tokenEndpointURL: URL? { fatalError() }

        var redirectURI: String? { fatalError() }

        var scope: String? { fatalError() }

        var additionalAuthorizationRequestParameters: [String: String]? { fatalError() }

        var additionalTokenRequestParameters: [String: String]? { fatalError() }

        let additionalHeaders: [String: String]? = ["test": "test"]

        var authorizationServerCertificate: Data { fatalError() }

        var tokenServerCertificate: Data { fatalError() }

        var apiServerCertificate: Data { fatalError() }

        var bankingRequestTranslator: BankingRequestTranslator { fatalError() }

        var bankServiceProvider: BankServiceProvider { fatalError() }

    }
}
