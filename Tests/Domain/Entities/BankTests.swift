//
//  BankTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class BankTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func test_Init_TakesIdNameAndProviderId() {
        let sut = Bank(id: "ID", name: "Test Bank", bankServiceProviderId: "123")
        
        XCTAssertEqual(sut.id, "ID")
        XCTAssertEqual(sut.name, "Test Bank")
        XCTAssertEqual(sut.bankServiceProviderId, "123")
    }
    
    func test_Equal_TrueForSameId() {
        let lhs = Bank(id: "ID1", name: "", bankServiceProviderId: "")
        let rhs = Bank(id: "ID1", name: "", bankServiceProviderId: "")
        
        XCTAssertEqual(lhs, rhs)
    }
    
    func test_Equal_FalseForDifferentId() {
        let lhs = Bank(id: "ID1", name: "", bankServiceProviderId: "")
        let rhs = Bank(id: "ID2", name: "", bankServiceProviderId: "")
        
        XCTAssertNotEqual(lhs, rhs)
    }
}
