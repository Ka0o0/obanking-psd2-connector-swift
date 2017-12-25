//
//  BankAccountTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 25.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class BankAccountTests: XCTestCase {

    func test_Equal_TrueForSameBankAccount() {
        guard let sepaNumber = SepaAccountNumber(iban: "CZ0708000000001019382023", bic: "GIBACZPX") else {
            XCTFail("Couldn't create valid sepa number")
            return
        }

        let lhs = BankAccount(bankId: "asdf", id: "asdf", accountNumber: sepaNumber)
        let rhs = BankAccount(bankId: "asdf", id: "asdf", accountNumber: sepaNumber)

        XCTAssertEqual(lhs, rhs)
    }

    func test_Equal_FalseForDifferentBankId() {
        guard let sepaNumber = SepaAccountNumber(iban: "CZ0708000000001019382023", bic: "GIBACZPX") else {
            XCTFail("Couldn't create valid sepa number")
            return
        }

        let lhs = BankAccount(bankId: "asdf", id: "asdf", accountNumber: sepaNumber)
        let rhs = BankAccount(bankId: "a", id: "asdf", accountNumber: sepaNumber)

        XCTAssertNotEqual(lhs, rhs)
    }

    func test_Equal_FalseForDifferentBankAccountId() {
        guard let sepaNumber = SepaAccountNumber(iban: "CZ0708000000001019382023", bic: "GIBACZPX") else {
            XCTFail("Couldn't create valid sepa number")
            return
        }

        let lhs = BankAccount(bankId: "asdf", id: "asdfa", accountNumber: sepaNumber)
        let rhs = BankAccount(bankId: "asdf", id: "asdf", accountNumber: sepaNumber)

        XCTAssertNotEqual(lhs, rhs)
    }

    func test_Equal_FalseForDifferentAccountNumber() {
        guard let lhsSepaNumber = SepaAccountNumber(iban: "CZ0708000000001019382023", bic: "GIBACZPX") else {
            XCTFail("Couldn't create valid sepa number")
            return
        }
        guard let rhsSepaNumber = SepaAccountNumber(iban: "AT611904300234573201", bic: "XXXXXXX") else {
            XCTFail("Couldn't create valid sepa number")
            return
        }

        let lhs = BankAccount(bankId: "asdf", id: "asdf", accountNumber: lhsSepaNumber)
        let rhs = BankAccount(bankId: "asdf", id: "asdf", accountNumber: rhsSepaNumber)

        XCTAssertNotEqual(lhs, rhs)
    }
}
