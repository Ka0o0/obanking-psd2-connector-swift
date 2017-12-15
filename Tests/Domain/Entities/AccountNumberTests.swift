//
//  AccountNumberTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class AccountNumberTests: XCTestCase {

    private class AccountNumberMock: AccountNumber {
        func equals(other: AccountNumber) -> Bool {
            return false
        }
    }
}
