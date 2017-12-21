//
//  OAuth2BankServiceConnectionInformationTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class OAuth2BankServiceConnectionInformationTests: XCTestCase {

    func test_Init_TakesRequired() {
        let sut = OAuth2BankServiceConnectionInformation(
            bankServiceProviderId: "test",
            accessToken: "accesstoken",
            tokenType: "bearer"
        )

        XCTAssertEqual(sut.accessToken, "accesstoken")
        XCTAssertEqual(sut.tokenType, "bearer")
    }

    func test_Init_TakesOptional() {
        let expirationDate = Date(timeIntervalSinceNow: 1000)

        let sut = OAuth2BankServiceConnectionInformation(
            bankServiceProviderId: "test",
            accessToken: "",
            tokenType: "",
            expirationDate: expirationDate,
            refreshToken: "refreshtoken",
            scope: "test"
        )

        XCTAssertEqual(sut.expirationDate, expirationDate)
        XCTAssertEqual(sut.refreshToken, "refreshtoken")
        XCTAssertEqual(sut.scope, "test")
    }
}
