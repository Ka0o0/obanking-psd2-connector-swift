//
//  AmountTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class AmountTests: XCTestCase {
    
    func test_Init_TakesValuePrecisionAndCurrency() {
        let sut = Amount(value: 100, precision: 2, currency: Currency.EUR)
        
        XCTAssertEqual(sut.value, 100)
        XCTAssertEqual(sut.precision, 2)
        XCTAssertEqual(sut.currency, Currency.EUR)
    }
    
    func test_Equality_TrueForSameAmount() {
        let lhs = Amount(value: 10, precision: 2, currency: .EUR)
        let rhs = Amount(value: 10, precision: 2, currency: .EUR)
        
        XCTAssertEqual(lhs, rhs)
    }
    
    func test_Equality_FalseForDifferentValue() {
        let lhs = Amount(value: 9, precision: 2, currency: .EUR)
        let rhs = Amount(value: 10, precision: 2, currency: .EUR)
        
        XCTAssertNotEqual(lhs, rhs)
    }
    
    func test_Equality_FalseForDifferentPrecision() {
        let lhs = Amount(value: 10, precision: 1, currency: .EUR)
        let rhs = Amount(value: 10, precision: 2, currency: .EUR)
        
        XCTAssertNotEqual(lhs, rhs)
    }
    
    func test_Equality_FalseForDifferentCurrency() {
        let lhs = Amount(value: 10, precision: 2, currency: .EUR)
        let rhs = Amount(value: 10, precision: 2, currency: .GBP)
        
        XCTAssertNotEqual(lhs, rhs)
    }
}
