//
//  OAuth2BankServiceProviderAuthenticationRequestTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class OAuth2BankServiceProviderAuthenticationRequestTests: XCTestCase {

    func test_Init_TakesRequired() {
        let authorizationEndpointURL = URL(fileURLWithPath: "temp")

        let sut = OAuth2BankServiceProviderAuthenticationRequest(
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "johns_app"
        )

        XCTAssertEqual(sut.authorizationEndpointURL, authorizationEndpointURL)
        XCTAssertEqual(sut.clientId, "johns_app")
    }

    func test_Init_TakesOptionals() {
        let authorizationEndpointURL = URL(fileURLWithPath: "temp")
        let tokenEndpointURL = URL(fileURLWithPath: "another")

        let sut = OAuth2BankServiceProviderAuthenticationRequest(
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "johns_app",
            clientSecret: "secret",
            tokenEndpointURL: tokenEndpointURL,
            redirectURI: "redirectme",
            scope: "create+delete",
            additionalAuthorizationRequestParameters: ["john": "doe"],
            additionalTokenRequestParameters: ["giveme": "mytoken"]
        )

        XCTAssertEqual(sut.clientSecret, "secret")
        XCTAssertEqual(sut.tokenEndpointURL, tokenEndpointURL)
        XCTAssertEqual(sut.redirectURI, "redirectme")
        XCTAssertEqual(sut.scope, "create+delete")
        if let additionalAuthorizationRequestParameters = sut.additionalAuthorizationRequestParameters {
            XCTAssertEqual(additionalAuthorizationRequestParameters, ["john": "doe"])
        } else {
            XCTFail("additionalAuthorizationRequestParameters should not be null")
        }

        if let additionalTokenRequestParameters = sut.additionalTokenRequestParameters {
            XCTAssertEqual(additionalTokenRequestParameters, ["giveme": "mytoken"])
        } else {
            XCTFail("additionalTokenRequestParameters should not be null")
        }
    }
}
