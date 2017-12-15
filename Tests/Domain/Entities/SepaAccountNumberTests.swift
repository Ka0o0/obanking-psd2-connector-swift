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
        guard let sut = SepaAccountNumber(iban: "AT611904300234573201", bic: "XXXXXXX") else {
            XCTFail("Invalid Sepa Account Number although valid")
            return
        }

        XCTAssertEqual(sut.iban, "AT611904300234573201")
        XCTAssertEqual(sut.bic, "XXXXXXX")
    }

    func test_Init_ReturnsNilForInvalidIban() {
        let sut = SepaAccountNumber(iban: "AT", bic: "XXXXX")
        XCTAssertNil(sut)
    }

    func test_Implements_AccountNumber() {
        guard let sut = SepaAccountNumber(iban: "AT611904300234573201", bic: "") else {
            XCTFail("Invalid Sepa Account Number although valid")
            return
        }

        XCTAssertTrue((sut as Any) is AccountNumber)
    }

    func test_Equality_TrueForSameAccountNumbers() {
        guard let lhs = SepaAccountNumber(iban: "AT611904300234573201", bic: "XXXXXXX") else {
            XCTFail("Invalid Sepa Account Number although valid")
            return
        }
        guard let rhs = SepaAccountNumber(iban: "AT611904300234573201", bic: "XXXXXXX") else {
            XCTFail("Invalid Sepa Account Number although valid")
            return
        }

        XCTAssertEqual(lhs, rhs)
    }

    func test_Equality_FalseIfIbanMismatch() {
        guard let lhs = SepaAccountNumber(iban: "AT611904300234573201", bic: "XXXXXXX") else {
            XCTFail("Invalid Sepa Account Number although valid")
            return
        }
        guard let rhs = SepaAccountNumber(iban: "CZ4201000000195505030267", bic: "XXXXXXX") else {
            XCTFail("Invalid Sepa Account Number although valid")
            return
        }

        XCTAssertNotEqual(lhs, rhs)
    }

    func test_Equality_FalseIfBicMismatch() {
        guard let lhs = SepaAccountNumber(iban: "AT611904300234573201", bic: "XXXXXXX") else {
            XCTFail("Invalid Sepa Account Number although valid")
            return
        }
        guard let rhs = SepaAccountNumber(iban: "AT611904300234573201", bic: "XXX") else {
            XCTFail("Invalid Sepa Account Number although valid")
            return
        }

        XCTAssertNotEqual(lhs, rhs)
    }
}
