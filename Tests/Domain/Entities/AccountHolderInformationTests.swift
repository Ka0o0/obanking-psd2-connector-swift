//
//  AccountHolderInformationTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class AccountHolderInformationTests: XCTestCase {

    func test_Init_RequiresFullName() {
        let sut = AccountHolderInformation(fullName: "John Doe")

        XCTAssertEqual(sut.fullName, "John Doe")
    }

    func test_Init_TakesFirstAndLastName() {
        let sut = AccountHolderInformation(
            fullName: "John Doe",
            firstName: "John",
            lastName: "Doe"
        )

        XCTAssertEqual(sut.fullName, "John Doe")
        XCTAssertEqual(sut.firstName, "John")
        XCTAssertEqual(sut.lastName, "Doe")
    }
}
