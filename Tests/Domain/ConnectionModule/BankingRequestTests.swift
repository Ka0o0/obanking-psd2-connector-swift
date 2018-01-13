//
//  BankingRequestTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class BankingRequestTests: XCTestCase {

    private class TestBankingRequest: BankingRequest {
        typealias Result = Bool
    }
}
