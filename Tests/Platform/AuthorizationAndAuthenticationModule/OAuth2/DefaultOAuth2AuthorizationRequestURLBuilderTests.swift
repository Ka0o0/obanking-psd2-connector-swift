//
//  DefaultOAuth2AuthorizationRequestURLBuilderTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class DefaultOAuth2AuthorizationRequestURLBuilderTests: XCTestCase {

    var baseURL: URL! = URL(string: "https://authorization-server.com/auth")

    func test_Make_BuildsCorrectMinimumRequestString() {
        var expectedURLString = "https://authorization-server.com/auth?response_type=code"
        expectedURLString += "&client_id=example"

        guard let expectedURL = URL(string: expectedURLString) else {
            XCTFail("Should not happen")
            return
        }

        let mockedRequest = OAuth2AuthorizationRequest(
            bankingServiceProviderId: "test",
            authorizationEndpointURL: baseURL,
            clientId: "example"
        )

        let sut = DefaultOAuth2AuthorizationRequestURLBuilder()
        let result = sut.makeAuthorizationCodeRequestURL(for: mockedRequest, adding: nil)

        XCTAssertEqual(result, expectedURL)
    }

    func test_Make_BuildsCorrectMaximumRequestString() {
        let mockedRequest = OAuth2AuthorizationRequest(
            bankingServiceProviderId: "test",
            authorizationEndpointURL: baseURL,
            clientId: "example",
            clientSecret: "secret",
            redirectURI: "myapp://handleme",
            scope: "create+delete"
        )

        let sut = DefaultOAuth2AuthorizationRequestURLBuilder()
        let state = UUID()
        let result = sut.makeAuthorizationCodeRequestURL(for: mockedRequest, adding: state)

        var expectedURLString = "https://authorization-server.com/auth"
        expectedURLString += "?response_type=code"
        expectedURLString += "&client_id=example"
        expectedURLString += "&redirect_uri=myapp://handleme"
        expectedURLString += "&scope=create+delete"
        expectedURLString += "&state=" + state.uuidString

        guard let expectedURL = URL(string: expectedURLString) else {
            XCTFail("Should not happen")
            return
        }

        XCTAssertEqual(result, expectedURL)
    }

    func test_Make_UsesAdditionalParameters() {
        var expectedURLString = "https://authorization-server.com/auth?response_type=code"
        expectedURLString += "&client_id=example"
        expectedURLString += "&test=asdf%20asdf"

        guard let expectedURL = URL(string: expectedURLString) else {
            XCTFail("Should not happen")
            return
        }

        let mockedRequest = OAuth2AuthorizationRequest(
            bankingServiceProviderId: "test",
            authorizationEndpointURL: baseURL,
            clientId: "example",
            additionalAuthorizationRequestParameters: [
                "test": "asdf asdf"
            ]
        )

        let sut = DefaultOAuth2AuthorizationRequestURLBuilder()
        let result = sut.makeAuthorizationCodeRequestURL(for: mockedRequest, adding: nil)

        XCTAssertEqual(result, expectedURL)
    }

}
