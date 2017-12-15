//
//  CurrencyTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import OBankingConnector

class CurrencyTests: XCTestCase {

    func test_EUR_ExistsAndHasProperName() {
        let sut = Currency.EUR
        XCTAssertEqual(sut.name, "Euro")
    }

    func test_GBP_ExistsAndHasProperName() {
        let sut = Currency.GBP
        XCTAssertEqual(sut.name, "Great British Pound")
    }
}
