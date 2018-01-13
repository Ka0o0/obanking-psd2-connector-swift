//
//  DefaultBankServiceProviderAuthorizationProcessorFactoryTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
@testable import OBankingConnector

class DefaultAuthorizationProviderTests: XCTestCase {

    private var sut: DefaultAuthorizationProviderFactory!

    override func setUp() {
        super.setUp()

        sut = DefaultAuthorizationProviderFactory(
            oAuth2AuthorizationProcessorFactory: OAuth2ProcessorFactoryMock()
        )
    }
    func test_MakeAuthorizationProvider_ReturnsNilForUnknownBankServiceProviderConfiguration() {
        let configuration = UnknownBankServiceProviderConfiguration()
        let result = sut.makeAuthorizationProcessor(for: configuration)
        XCTAssertNil(result)
    }

    func test_MakeAuthorizationProvider_ReturnsOAuth2BankServiceProviderAuthenticationProvider() {
        let configuration = OAuth2BankServiceConfigurationMock()
        let result = sut.makeAuthorizationProcessor(for: configuration)
        XCTAssertTrue(result is OAuth2AuthorizationProvider)
    }
}

private extension DefaultAuthorizationProviderTests {

    class OAuth2BankServiceProviderAuthorizationProcessorMock: OAuth2AuthorizationProvider {
        func authorize() -> Single<AuthorizationResult> {
            fatalError()
        }
    }

    class OAuth2ProcessorFactoryMock: OAuth2AuthorizationProviderFactory {
        func makeOAuth2BankServiceProviderAuthorizationProcessor(for configuration: OAuth2BankServiceConfiguration)
            -> OAuth2AuthorizationProvider {
            return OAuth2BankServiceProviderAuthorizationProcessorMock()
        }
    }

    class UnknownBankServiceProviderConfiguration: BankServiceProviderConfiguration {
        let bankServiceProvider: BankServiceProvider = BankServiceProviderMock(id: "unknown", name: "unknown")
    }
}
