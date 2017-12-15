//
//  BankingRequestResultTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class BankingRequestResultTests: XCTestCase {

    private class BankingRequestMock: BankingRequest {
        typealias ResultType = Bool
    }

    private enum ErrorMock: Error {
        case test
    }

    func test_Success_TakesResult() {
        _ = BankingRequestResult<BankingRequestMock>.success(result: false)
    }

    func test_Failure_TakesError() {
        _ = BankingRequestResult<BankingRequestMock>.failure(error: ErrorMock.test)
    }
}
