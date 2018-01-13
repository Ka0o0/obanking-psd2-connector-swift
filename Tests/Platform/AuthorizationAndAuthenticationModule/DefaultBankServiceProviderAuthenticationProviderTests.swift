//
//  DefaultBankServiceProviderAuthenticationProviderTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import OBankingConnector

class DefaultBankServiceProviderAuthenticationProviderTests: XCTestCase {

    func test_AuthenticateAgainst() {
        let configuration = OBankingConnectorConfiguration(
            bankServiceProviderConfigurations: [
                BankServiceProviderConfigurationMock()
            ]
        )
        let configurationParser = ConfigurationParser(configuration: configuration)
        let sut = DefaultBankServiceProviderAuthenticationProvider(
            authorizationProcessorFactory: BankServiceProviderAuthorizationProcessorFactoryMock(),
            configurationParser: configurationParser
        )

        do {
            let result = try sut.authenticate(against: BankServiceProviderMock(
                id: "BankServiceProviderAuthorizationProcessorMock",
                name: ""
            )).toBlocking(timeout: 3).single()

            XCTAssertTrue(result is BankServiceConnectionInformationMock)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}

private extension DefaultBankServiceProviderAuthenticationProviderTests {

    class BankServiceProviderConfigurationMock: BankServiceProviderConfiguration {
        let bankServiceProvider: BankServiceProvider = BankServiceProviderMock(
            id: "BankServiceProviderAuthorizationProcessorMock",
            name: ""
        )
    }

    class BankServiceConnectionInformationMock: BankServiceConnectionInformation {
        let bankServiceProviderId = "BankServiceProviderAuthorizationProcessorMock"
    }

    class BankServiceProviderAuthorizationProcessorMock: BankServiceProviderAuthorizationProcessor {
        func authorize() -> Single<BankServiceProviderAuthenticationResult> {
            return Single.just(BankServiceConnectionInformationMock())
        }
    }

    class BankServiceProviderAuthorizationProcessorFactoryMock: BankServiceProviderAuthorizationProcessorFactory {

        var lastConfiguration: BankServiceProviderConfiguration?

        func makeAuthorizationProcessor(for configuration: BankServiceProviderConfiguration)
            -> BankServiceProviderAuthorizationProcessor? {
            lastConfiguration = configuration
            return BankServiceProviderAuthorizationProcessorMock()
        }
    }
}
