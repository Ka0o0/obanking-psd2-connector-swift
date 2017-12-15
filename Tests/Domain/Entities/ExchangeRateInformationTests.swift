//
//  ExchangeRateInformationTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class ExchangeRateInformationTests: XCTestCase {

    func test_Init_TakesRequired() {
        guard let mockedRate = Decimal(string: "10.2") else {
            XCTFail("Could not create Decimal")
            return
        }
        let mockedDate = Date()

        let sut = ExchangeRateInformation(source: .EUR, target: Currency.GBP, rate: mockedRate, date: mockedDate)

        XCTAssertEqual(sut.source, Currency.EUR)
        XCTAssertEqual(sut.target, Currency.GBP)
        XCTAssertEqual(sut.rate, mockedRate)
        XCTAssertEqual(sut.date, mockedDate)
    }

    func test_Equality_TrueForSameExchangeRateInformation() {
        guard let mockedRate = Decimal(string: "10.2") else {
            XCTFail("Could not create Decimal")
            return
        }
        let mockedDate = Date()

        let lhs = ExchangeRateInformation(source: .EUR, target: .GBP, rate: mockedRate, date: mockedDate)
        let rhs = ExchangeRateInformation(source: .EUR, target: .GBP, rate: mockedRate, date: mockedDate)

        XCTAssertEqual(lhs, rhs)
    }

    func test_Equality_TrueForDifferentDate() {
        guard let mockedRate = Decimal(string: "10.2") else {
            XCTFail("Could not create Decimal")
            return
        }

        let lhs = ExchangeRateInformation(
            source: .EUR,
            target: .GBP,
            rate: mockedRate,
            date: Date().addingTimeInterval(10)
        )

        let rhs = ExchangeRateInformation(source: .EUR, target: .GBP, rate: mockedRate, date: Date())

        XCTAssertEqual(lhs, rhs)
    }

    func test_Equality_FalseForDifferentSource() {
        guard let mockedRate = Decimal(string: "10.2") else {
            XCTFail("Could not create Decimal")
            return
        }
        let date = Date()

        let lhs = ExchangeRateInformation(source: .EUR, target: .GBP, rate: mockedRate, date: date)
        let rhs = ExchangeRateInformation(source: .GBP, target: .GBP, rate: mockedRate, date: date)

        XCTAssertNotEqual(lhs, rhs)
    }

    func test_Equality_FalseForDifferentTarget() {
        guard let mockedRate = Decimal(string: "10.2") else {
            XCTFail("Could not create Decimal")
            return
        }
        let date = Date()

        let lhs = ExchangeRateInformation(source: .EUR, target: .GBP, rate: mockedRate, date: date)
        let rhs = ExchangeRateInformation(source: .EUR, target: .EUR, rate: mockedRate, date: date)

        XCTAssertNotEqual(lhs, rhs)
    }

    func test_Equality_FalseForDifferentRate() {
        guard let mockedRateLhs = Decimal(string: "10.2") else {
            XCTFail("Could not create Decimal")
            return
        }
        guard let mockedRateRhs = Decimal(string: "10") else {
            XCTFail("Could not create Decimal")
            return
        }
        let date = Date()

        let lhs = ExchangeRateInformation(source: .EUR, target: .GBP, rate: mockedRateLhs, date: date)
        let rhs = ExchangeRateInformation(source: .EUR, target: .GBP, rate: mockedRateRhs, date: date)

        XCTAssertNotEqual(lhs, rhs)
    }
}
