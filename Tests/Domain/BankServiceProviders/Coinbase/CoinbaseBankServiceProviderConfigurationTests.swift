//
//  CoinbaseBankServiceProviderConfigurationTests.swift
//  OBankingConnectorTests-iOS
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class CoinbaseBankServiceProviderConfigurationTests: XCTestCase {

    func test_Init_TakesParameters() {
        let sut = CoinbaseBankServiceProviderConfiguration(
            clientId: "test",
            clientSecret: "secret",
            redirectURI: "redirect",
            accessScope: .full
        )

        XCTAssertEqual(sut.clientId, "test")
        XCTAssertEqual(sut.clientSecret, "secret")
        XCTAssertEqual(sut.redirectURI, "redirect")

        XCTAssertTrue((sut as Any) is OAuth2BankServiceConfiguration)
    }
}
