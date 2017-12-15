//
//  BankServiceProviderTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class BankServiceProviderTests: XCTestCase {

    func test_Init_TakesIdAndName() {
        let sut = BankServiceProvider(id: "1234", name: "Example Provider")

        XCTAssertEqual(sut.id, "1234")
        XCTAssertEqual(sut.name, "Example Provider")
    }
}
