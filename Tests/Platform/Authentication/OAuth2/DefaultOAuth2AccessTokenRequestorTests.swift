//
//  OAuth2AccessTokenRequestorTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxBlocking
@testable import OBankingConnector

class DefaultOAuth2AccessTokenRequestorTests: XCTestCase {

    private let state = UUID()
    private var webClient: WebClientMock!
    private var sut: DefaultOAuth2AccessTokenRequestor!
    private var authorizationEndpointURL: URL! = URL(string: "https://authorization-server.com/auth")
    private var tokenEndpointURL: URL! = URL(string: "https://authorization-server.com/token")
    private let mockedAccessToken = "MTQ0NjJkZmQ5OTM2NDE1ZTZjNGZmZjI3"
    private let mockedRefreshToken = "IwOGYzYTlmM2YxOTQ5MGE3YmNmMDFkNTVk"
    private let expirationDate = Date(timeIntervalSinceNow: 100)

    private var exampleValidResponseData: Data {
        var responseJSON = "{"
        responseJSON += "\"access_token\":\"" + mockedAccessToken + "\","
        responseJSON += "\"token_type\":\"bearer\","
        responseJSON += "\"expires_in\":" + String(expirationDate.timeIntervalSinceNow) + ","
        responseJSON += "\"refresh_token\":\"" + mockedRefreshToken + "\","
        responseJSON += "\"token_type\":\"bearer\","
        responseJSON += "\"scope\":\"create\","
        responseJSON += "\"state\":\"" + state.uuidString + "\""
        responseJSON += "}"

        guard let data = responseJSON.data(using: .utf8) else {
            fatalError()
        }
        return data
    }

    override func setUp() {
        super.setUp()

        webClient = WebClientMock()
        sut = DefaultOAuth2AccessTokenRequestor(webClient: webClient)
    }

    func test_ClaimAccessTokenForAuthorizationToken_UsesAuthUrlIfNoTokenURLSpecified() {
        let request = OAuth2BankServiceProviderAuthenticationRequest(
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "example"
        )

        _ = testRequest(request: request)

        guard let lastRequest = webClient.lastRequest else {
            XCTFail("Should have made a request")
            return
        }

        XCTAssertEqual(lastRequest.method, .post)
        XCTAssertEqual(lastRequest.url, authorizationEndpointURL)
        if let parameters = lastRequest.parameters as? [String: String] {
            let expectedParameters: [String: String] = [
                "client_id": "example",
                "grant_type": "authorization_code",
                "code": "thisonetoken"
            ]

            XCTAssertEqual(parameters, expectedParameters)
        } else {
            XCTFail("Invalid parameters provided")
        }
    }

    func test_ClaimAccessTokenForAuthorizationToken_UsesTokenURLIfSpecified() {
        let request = OAuth2BankServiceProviderAuthenticationRequest(
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "example",
            clientSecret: "secret",
            tokenEndpointURL: tokenEndpointURL,
            redirectURI: "target_uri",
            additionalRequestHeaders: ["test": "asdf"]
        )

        _ = testRequest(request: request)

        guard let lastRequest = webClient.lastRequest else {
            XCTFail("Should have made a request")
            return
        }

        XCTAssertEqual(lastRequest.method, .post)
        XCTAssertEqual(lastRequest.url, tokenEndpointURL)
        if let parameters = lastRequest.parameters as? [String: String] {
            let expectedParameters: [String: String] = [
                "client_id": "example",
                "client_secret": "secret",
                "grant_type": "authorization_code",
                "code": "thisonetoken",
                "redirect_uri": "target_uri"
            ]

            XCTAssertEqual(parameters, expectedParameters)
        } else {
            XCTFail("Invalid parameters provided")
        }

        if let headers = lastRequest.headers {
            XCTAssertEqual(headers, ["test": "asdf"])
        } else {
            XCTFail("Invalid headers provided")
        }
    }

    func test_ClaimAccessTokenForAuthorizationToken_ParsesResponseCorrectly() {
        let request = OAuth2BankServiceProviderAuthenticationRequest(
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "example"
        )

        guard let result = testRequest(request: request) else {
            XCTFail("Result must not be nil")
            return
        }

        XCTAssertEqual(result.accessToken, mockedAccessToken)
        XCTAssertEqual(result.refreshToken, mockedRefreshToken)
        XCTAssertEqual(result.scope, "create")
        XCTAssertEqual(result.tokenType, "bearer")
        if let resultExpirationDate = result.expirationDate {
            let timeDifference = resultExpirationDate.timeIntervalSinceReferenceDate -
                expirationDate.timeIntervalSinceReferenceDate
            XCTAssertTrue(timeDifference < 10)
        } else {
            XCTFail("No expiration date set")
        }
    }

    private func testRequest(request: OAuth2BankServiceProviderAuthenticationRequest) ->
        OAuth2BankServiceConnectionInformation? {

        webClient.responseData = exampleValidResponseData
        do {
            return try sut.requestAccessToken(for: request, authorizationToken: "thisonetoken")
                .toBlocking()
                .first()
        } catch let error {
            XCTFail(String(describing: error))
            return nil
        }
    }
}
