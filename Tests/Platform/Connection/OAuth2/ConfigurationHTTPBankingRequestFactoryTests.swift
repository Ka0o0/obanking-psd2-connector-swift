//
//  ConfigurationHTTPBankingRequestFactoryTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 17.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class ConfigurationHTTPBankingRequestFactoryTests: XCTestCase {

    func test_MakeRequestFor_MakesProperRequest() {

        let translator = BankingRequestTranslatorMock()
        let configurationMock = BankServiceProviderConfigurationMock(
            bankingRequestTranslator: translator
        )
        let bankServiceProviderConfigurations: [BankServiceProviderConfiguration] = [
            configurationMock
        ]
        let configuration = OBankingConnectorConfiguration(
            bankServiceProviderConfigurations: bankServiceProviderConfigurations
        )
        let configurationParser = ConfigurationParser(
            configuration: configuration
        )

        let expectedHTTPRequest = HTTPRequest(
            method: .post,
            url: URL(fileURLWithPath: "test"),
            parameters: ["bankId": "test"],
            encoding: ParameterEncoding.json,
            headers: nil
        )

        translator.nextRequest = expectedHTTPRequest
        let sut = ConfigurationHTTPBankingRequestFactory(configurationParser: configurationParser)

        let result = sut.makeHTTPRequest(
            for: GetBankAccountRequest(bankId: "test"),
            bankServiceProvider: BankServiceProviderMock(id: "test", name: "test")
        )

        XCTAssertEqual(result?.url, expectedHTTPRequest.url)
    }
}

private extension ConfigurationHTTPBankingRequestFactoryTests {

    class BankingRequestTranslatorMock: BankingRequestTranslator {

        var nextRequest: HTTPRequest?

        func makeHTTPRequest<T: BankingRequest>(from bankingRequest: T) -> HTTPRequest? {
            return nextRequest
        }
    }

    class BankServiceProviderConfigurationMock: OAuth2BankServiceConfiguration {
        let bankServiceProvider: BankServiceProvider = BankServiceProviderMock(id: "test", name: "test")
        let authorizationEndpointURL: URL = URL(fileURLWithPath: "test")
        let clientId: String = ""
        let clientSecret: String? = nil
        let tokenEndpointURL: URL? = nil
        let redirectURI: String? = nil
        let scope: String? = nil
        let additionalAuthorizationRequestParameters: [String: String]? = nil
        let additionalTokenRequestParameters: [String: String]? = nil
        let additionalHeaders: [String: String]? = nil
        let bankingRequestTranslator: BankingRequestTranslator

        init(bankingRequestTranslator: BankingRequestTranslator) {
            self.bankingRequestTranslator = bankingRequestTranslator
        }
    }
}
