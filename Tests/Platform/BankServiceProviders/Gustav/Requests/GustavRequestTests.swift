//
//  GustavRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class GustavRequestTests: XCTestCase {

    var baseURL: URL! = URL(string: "https://api.csas.cz/sandbox/webapi/api/v3")

    var sepaAccountNumberMock: SepaAccountNumber! = SepaAccountNumber(iban: "CZ6508000000003766862329", bic: "GIBACZPX")
    var bankAccountMock: BankAccount {
        return BankAccount(
            bankId: "csas",
            id: "asdf",
            accountNumber: sepaAccountNumberMock
        )
    }
}
