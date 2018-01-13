//
//  DefaultAuthorizationModuleTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import OBankingConnector

class DefaultAuthorizationModuleTests: XCTestCase {

    func test_AuthenticateAgainst() {
        let configuration = OBankingConnectorConfiguration(
            bankServiceProviderConfigurations: [
                BankServiceProviderConfigurationMock()
            ]
        )
        let configurationParser = ConfigurationParser(configuration: configuration)
        let sut = DefaultAuthorizationModule(
            authorizationProviderFactory: BankServiceProviderAuthorizationProcessorFactoryMock(),
            configurationParser: configurationParser
        )

        do {
            let result = try sut.authorize(against: BankServiceProviderMock(
                id: "BankServiceProviderAuthorizationProcessorMock",
                name: ""
            )).toBlocking(timeout: 3).single()

            XCTAssertTrue(result is BankServiceConnectionInformationMock)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}

private extension DefaultAuthorizationModuleTests {

    class BankServiceProviderConfigurationMock: BankServiceProviderConfiguration {
        let bankServiceProvider: BankServiceProvider = BankServiceProviderMock(
            id: "BankServiceProviderAuthorizationProcessorMock",
            name: ""
        )
    }

    class BankServiceConnectionInformationMock: BankServiceConnectionInformation {
        let bankServiceProviderId = "BankServiceProviderAuthorizationProcessorMock"
    }

    class BankServiceProviderAuthorizationProcessorMock: AuthorizationProvider {
        func authorize() -> Single<AuthorizationResult> {
            return Single.just(BankServiceConnectionInformationMock())
        }
    }

    class BankServiceProviderAuthorizationProcessorFactoryMock: AuthorizationProviderFactory {

        var lastConfiguration: BankServiceProviderConfiguration?

        func makeAuthorizationProvider(for configuration: BankServiceProviderConfiguration)
            -> AuthorizationProvider? {
            lastConfiguration = configuration
            return BankServiceProviderAuthorizationProcessorMock()
        }
    }
}
