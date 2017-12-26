//
//  GustavTransactionTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class GustavTransactionTests: XCTestCase {

    var sepaAccountNumberMock: SepaAccountNumber! = SepaAccountNumber(iban: "CZ6508000000003766862329", bic: "GIBACZPX")
    var bankAccountMock: BankAccount!

    override func setUp() {
        super.setUp()

        bankAccountMock = BankAccount(
            bankId: "csas",
            id: "asdf",
            accountNumber: sepaAccountNumberMock
        )
    }

    func test_ToTransaction_SuccessfulConversion() {
        let bookingDate = Date().addingTimeInterval(-100)
        let valuationDate = Date().addingTimeInterval(-50)
        let sut = GustavTransaction(
            id: "transaction01",
            accountParty: GustavTransaction.AccountParty(
                iban: "CZ6508000000003766862329",
                bic: "GIBACZPX",
                partyInfo: "John Doe",
                partyDescription: "1235"
            ),
            amount: GustavBalance(value: 100, precision: 2, currency: "CZK"),
            amountSender: GustavBalance(value: 200, precision: 2, currency: "CZK"),
            bookingDate: bookingDate,
            valuationDate: valuationDate,
            payerNote: "Payer note",
            payeeNote: "Payee note",
            description: "description"
        )

        do {
            let result = try sut.toTransaction(associating: bankAccountMock)

            XCTAssertEqual(result.id, "transaction01")
            XCTAssertEqual(result.bankAccountNumberId, bankAccountMock.id)
            XCTAssertEqual(result.amount, Amount(value: 100, precision: 2, currency: .CZK))
            XCTAssertEqual(result.bookingDate, bookingDate)
            XCTAssertEqual(result.processingDate, valuationDate)
            XCTAssertEqual(result.text, "Payer note")
            XCTAssertEqual(result.notes, "description")
            XCTAssertTrue(result.partyAccount.equals(other: sepaAccountNumberMock))
            XCTAssertEqual(result.partyAccountHolderInformation.fullName, "John Doe")
            XCTAssertNil(result.exchangeRateInformation)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    func test_ToTransaction_ConsidersExchangeRate() {
        let bookingDate = Date().addingTimeInterval(-100)
        let valuationDate = Date().addingTimeInterval(-50)
        let sut = GustavTransaction(
            id: "transaction01",
            accountParty: GustavTransaction.AccountParty(
                iban: "CZ6508000000003766862329",
                bic: "GIBACZPX",
                partyInfo: "John Doe",
                partyDescription: "1235"
            ),
            amount: GustavBalance(value: 256396, precision: 2, currency: "CZK"),
            amountSender: GustavBalance(value: 10000, precision: 2, currency: "EUR"),
            bookingDate: bookingDate,
            valuationDate: valuationDate,
            payerNote: "Payer note",
            payeeNote: "Payee note",
            description: "description"
        )

        do {
            let result = try sut.toTransaction(associating: bankAccountMock)

            guard let exchangeRateInformation = result.exchangeRateInformation else {
                XCTFail("Exchange rate information must not be nil")
                return
            }

            XCTAssertEqual(exchangeRateInformation.date, valuationDate)
            XCTAssertEqual(exchangeRateInformation.source, .EUR)
            XCTAssertEqual(exchangeRateInformation.target, .CZK)
            XCTAssertEqual(exchangeRateInformation.rate, Decimal(25.6396))
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

    func test_ToTransaction_ConsidersOutboundTransaction() {
        let bookingDate = Date().addingTimeInterval(-100)
        let valuationDate = Date().addingTimeInterval(-50)
        let sut = GustavTransaction(
            id: "transaction01",
            accountParty: GustavTransaction.AccountParty(
                iban: "CZ6508000000003766862329",
                bic: "GIBACZPX",
                partyInfo: "John Doe",
                partyDescription: "1235"
            ),
            amount: GustavBalance(value: -256396, precision: 2, currency: "CZK"),
            amountSender: GustavBalance(value: -10000, precision: 2, currency: "EUR"),
            bookingDate: bookingDate,
            valuationDate: valuationDate,
            payerNote: "Payer note",
            payeeNote: "Payee note",
            description: "description"
        )

        do {
            let result = try sut.toTransaction(associating: bankAccountMock)

            XCTAssertEqual(result.amount, Amount(value: -10000, precision: 2, currency: .EUR))
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}
