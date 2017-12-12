//
//  SepaAccountNumberTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class SepaAccountNumberTests: XCTestCase {

    func test_Init_TakesIbanAndBic() {
        let sut = SepaAccountNumber(iban: "AT1234567890", bic: "XXXXXXX")

        XCTAssertEqual(sut.iban, "AT1234567890")
        XCTAssertEqual(sut.bic, "XXXXXXX")
    }

    func test_Implements_AccountNumber() {
        let sut = SepaAccountNumber(iban: "", bic: "")

        XCTAssertTrue((sut as Any) is AccountNumber)
    }

    func test_Equality_TrueForSameAccountNumbers() {
        let lhs = SepaAccountNumber(iban: "AT1234567890", bic: "XXXXXXX")
        let rhs = SepaAccountNumber(iban: "AT1234567890", bic: "XXXXXXX")

        XCTAssertEqual(lhs, rhs)
    }

    func test_Equality_FalseIfIbanMismatch() {
        let lhs = SepaAccountNumber(iban: "AT1234567", bic: "XXXXXXX")
        let rhs = SepaAccountNumber(iban: "AT1234567890", bic: "XXXXXXX")

        XCTAssertNotEqual(lhs, rhs)
    }

    func test_Equality_FalseIfBicMismatch() {
        let lhs = SepaAccountNumber(iban: "AT1234567890", bic: "XXXXXXX")
        let rhs = SepaAccountNumber(iban: "AT1234567890", bic: "XXX")

        XCTAssertNotEqual(lhs, rhs)
    }
}
