//
//  TransactionTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class TransactionTests: XCTestCase {

    func test_Init_TakesRequired() {
        let mockedPartyAccountNumber = AccountNumberMock(identifier: "partyAccountNumber")
        let mockedPartyAccountHolderInformation = AccountHolderInformation(fullName: "John Doe")
        let mockedAmount = Amount(value: 123, precision: 1, currency: .EUR)
        let mockedBookingDate = Date()

        let sut = Transaction(
            id: "example_transaction",
            bankId: "test",
            bankAccountId: "example_bank_account",
            partyAccount: mockedPartyAccountNumber,
            partyAccountHolderInformation: mockedPartyAccountHolderInformation,
            amount: mockedAmount,
            text: "Hello World!",
            bookingDate: mockedBookingDate
        )

        XCTAssertEqual(sut.id, "example_transaction")
        XCTAssertEqual(sut.bankId, "test")
        XCTAssertEqual(sut.bankAccountId, "example_bank_account")
        XCTAssertTrue(sut.partyAccount.equals(other: mockedPartyAccountNumber))
        XCTAssertEqual(sut.amount, mockedAmount)
        XCTAssertEqual(sut.text, "Hello World!")
        XCTAssertEqual(sut.bookingDate, mockedBookingDate)
        XCTAssertEqual(sut.textType, TransactionTextType.unknown)
        XCTAssertEqual(sut.partyAccountHolderInformation.fullName, mockedPartyAccountHolderInformation.fullName)
    }

    func test_Init_TakesOptionals() {
        guard let rate = Decimal(string: "10.2") else {
            XCTFail("Could not create Decimal")
            return
        }

        let mockedPartyAccountNumber = AccountNumberMock(identifier: "partyAccountNumber")
        let mockedPartyAccountHolderInformation = AccountHolderInformation(fullName: "John Doe")
        let mockedAmount = Amount(value: 123, precision: 1, currency: .EUR)
        let mockedBookingDate = Date()
        let mockedProcessingDate = Date()
        let mockedExchangeRateInformation = ExchangeRateInformation(
            source: .EUR,
            target: .GBP,
            rate: rate,
            date: Date()
        )

        let sut = Transaction(
            id: "example_transaction",
            bankId: "test",
            bankAccountId: "example_bank_account",
            partyAccount: mockedPartyAccountNumber,
            partyAccountHolderInformation: mockedPartyAccountHolderInformation,
            amount: mockedAmount,
            text: "Hello World!",
            bookingDate: mockedBookingDate,
            processingDate: mockedProcessingDate,
            textType: .paymentPurpose,
            notes: "HeyHey!",
            exchangeRateInformation: mockedExchangeRateInformation
        )

        XCTAssertEqual(sut.processingDate, mockedProcessingDate)
        XCTAssertEqual(sut.textType, TransactionTextType.paymentPurpose)
        XCTAssertEqual(sut.notes, "HeyHey!")
        XCTAssertEqual(sut.exchangeRateInformation, mockedExchangeRateInformation)
    }
}
