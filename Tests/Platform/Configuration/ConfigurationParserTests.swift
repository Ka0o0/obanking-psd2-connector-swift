//
//  ConfigurationParserTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class ConfigurationParserTests: XCTestCase {

    private class BankServiceProviderConfigurationMock: BankServiceProviderConfiguration {
        let bankServiceProviderId: String = "test"
    }

    func test_getBankServiceConfigurationFor_ReturnsNilForUnconfiguredBankService() {

        let bankServiceProviderConfigurations: [BankServiceProviderConfiguration] = []

        let configuration = OBankingConnectorConfiguration(
            bankServiceProviderConfigurations: bankServiceProviderConfigurations
        )

        let sut = ConfigurationParser(configuration: configuration)
        let exampleTestService = BankServiceProvider(id: "test", name: "test")

        let result = sut.getBankServiceConfiguration(for: exampleTestService)
        XCTAssertNil(result)
    }

    func test_getBankServiceConfigurationFor_ReturnsConfigForConfiguredBankService() {

        let bankServiceProviderConfigurations: [BankServiceProviderConfiguration] = [
            BankServiceProviderConfigurationMock()
        ]

        let configuration = OBankingConnectorConfiguration(
            bankServiceProviderConfigurations: bankServiceProviderConfigurations
        )

        let sut = ConfigurationParser(configuration: configuration)
        let exampleTestService = BankServiceProvider(id: "test", name: "test")

        guard let result = sut.getBankServiceConfiguration(for: exampleTestService) else {
            XCTFail("Need result")
            return
        }

        XCTAssertEqual(result.bankServiceProviderId, "test")
    }
}
