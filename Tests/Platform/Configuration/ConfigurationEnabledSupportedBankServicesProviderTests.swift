//
//  ConfigurationEnabledSupportedBankServicesProviderTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 30.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class ConfigurationEnabledSupportedBankServicesProviderTests: XCTestCase {

    func test_SupportedBankServices_SupportsGustav() {
        let sut = ConfigurationEnabledSupportedBankServicesProvider(
            configuration: OBankingConnectorConfiguration(
                bankServiceProviderConfigurations: [
                    GustavBankServiceProviderConfigurationMock()
                ]
            )
        )

        let result = sut.supportedBankServices

        XCTAssertEqual(result.map { $0.id }, [GustavBankServiceProvider.id])
    }
}

private extension ConfigurationEnabledSupportedBankServicesProviderTests {

    class GustavBankServiceProviderConfigurationMock: BankServiceProviderConfiguration {

        let bankServiceProvider: BankServiceProvider = GustavBankServiceProvider()
    }
}
