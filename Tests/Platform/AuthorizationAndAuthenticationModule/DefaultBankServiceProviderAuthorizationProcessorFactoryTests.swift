//
//  DefaultBankServiceProviderAuthorizationProcessorFactoryTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class DefaultBankServiceProviderAuthorizationProcessorFactoryTests: XCTestCase {

    private var sut: DefaultBankServiceProviderAuthorizationProcessorFactory!

    override func setUp() {
        super.setUp()

        sut = DefaultBankServiceProviderAuthorizationProcessorFactory()
    }
    func test_MakeAuthorizationProvider_ReturnsNilForUnknownBankServiceProviderConfiguration() {
        let configuration = UnknownBankServiceProviderConfiguration()
        let result = sut.makeAuthorizationProcessor(for: configuration)
        XCTAssertNil(result)
    }

    func test_MakeAuthorizationProvider_ReturnsOAuth2BankServiceProviderAuthenticationProvider() {
        let configuration = OAuth2BankServiceConfigurationMock()
        let result = sut.makeAuthorizationProcessor(for: configuration)
        XCTAssertTrue(result is OAuth2BankServiceProviderAuthorizationProcessor)
    }
}

private extension DefaultBankServiceProviderAuthorizationProcessorFactoryTests {

    class UnknownBankServiceProviderConfiguration: BankServiceProviderConfiguration {
        let bankServiceProvider: BankServiceProvider = BankServiceProviderMock(id: "unknown", name: "unknown")
    }
}
