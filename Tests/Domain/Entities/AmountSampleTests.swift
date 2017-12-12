//
//  AmountSampleTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class AmountSampleTests: XCTestCase {

    func test_Init_TakesAmountAndDate() {
        let mockedAmount = Amount(value: 10, precision: 2, currency: .EUR)
        let mockedDate = Date()
        let sut = AmountSample(amount: mockedAmount, date: mockedDate)

        XCTAssertEqual(sut.amount, mockedAmount)
        XCTAssertEqual(sut.date, mockedDate)
    }

    func test_Equality_TrueForSameSample() {
        let mockedAmount = Amount(value: 10, precision: 2, currency: .EUR)
        let mockedDate = Date()
        let lhs = AmountSample(amount: mockedAmount, date: mockedDate)
        let rhs = AmountSample(amount: mockedAmount, date: mockedDate)

        XCTAssertEqual(lhs, rhs)
    }

    func test_Equality_FalseForDifferentAmount() {
        let mockedDate = Date()
        let lhs = AmountSample(amount: Amount(value: 10, precision: 2, currency: .EUR), date: mockedDate)
        let rhs = AmountSample(amount: Amount(value: 1, precision: 2, currency: .EUR), date: mockedDate)

        XCTAssertNotEqual(lhs, rhs)
    }

    func test_Equality_FalseForDifferentDate() {
        let mockedAmount = Amount(value: 10, precision: 2, currency: .EUR)
        let lhs = AmountSample(amount: mockedAmount, date: Date())
        let rhs = AmountSample(amount: mockedAmount, date: Date().addingTimeInterval(10))

        XCTAssertNotEqual(lhs, rhs)
    }
}
