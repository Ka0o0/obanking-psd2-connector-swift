//
//  ConfigurationBankServiceProviderAuthenticationRequestFactoryProviderTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class ConfigurationBankServiceProviderAuthenticationRequestFactoryProviderTests: XCTestCase {

    private class BankServiceConfigurationMock: OAuth2BankServiceConfiguration {
        let authorizationEndpointURL: URL = URL(fileURLWithPath: "test")
        let clientId: String = "client"
        let clientSecret: String? = nil
        let tokenEndpointURL: URL? = nil
        let redirectURI: String? = nil
        let scope: String? = nil
        let bankServiceProviderId: String = "test"
        let additionalAuthorizationRequestParameters: [String: String]? = nil
        let additionalTokenRequestParameters: [String: String]? = nil
        let additionalHeaders: [String: String]? = nil
    }

    func test_make_ReturnsNilIfNoProviderConfigured() {
        let configuration = OBankingConnectorConfiguration(
            bankServiceProviderConfigurations: []
        )
        let sut = ConfigurationBankServiceProviderAuthenticationRequestFactoryProvider(
            configurationParser: ConfigurationParser(configuration: configuration)
        )

        XCTAssertNil(sut.makeAuthenticationRequestFactory(for: BankServiceProviderMock(id: "test", name: "test")))
    }

    func test_make_ReturnsOAuth2RequestFactory() {
        let configuration = OBankingConnectorConfiguration(
            bankServiceProviderConfigurations: [
                BankServiceConfigurationMock()
            ]
        )
        let sut = ConfigurationBankServiceProviderAuthenticationRequestFactoryProvider(
            configurationParser: ConfigurationParser(configuration: configuration)
        )
        let provider = BankServiceProviderMock(id: "test", name: "test")
        guard let result = sut.makeAuthenticationRequestFactory(for: provider) else {
            XCTFail("Should not be nil")
            return
        }

        let request = result.makeBankServiceProviderAuthenticationRequest()
        guard let oAuth2Request = request as? OAuth2BankServiceProviderAuthenticationRequest else {
            XCTFail("Request must be of OAuth2 type")
            return
        }

        XCTAssertEqual(oAuth2Request.authorizationEndpointURL, URL(fileURLWithPath: "test"))
    }

}
