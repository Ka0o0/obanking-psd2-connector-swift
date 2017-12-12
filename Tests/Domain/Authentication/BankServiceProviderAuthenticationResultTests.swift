//
//  BankServiceProviderAuthenticationResultTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift

@testable import OBankingConnector

class BankServiceProviderAuthenticationResultTests: XCTestCase {

    private class BankServiceConnectionInformationMock: BankServiceConnectionInformation {

    }

    private enum MockedError: Error {
        case test
    }

    func test_Success_TakesBankServiceConnectionInformation() {
        let connectionInformation = BankServiceConnectionInformationMock()

        _ = BankServiceProviderAuthenticationResult.success(
            bankServiceConnectionInformation: connectionInformation
        )
    }

    func test_Failure_TakesError() {
        _ = BankServiceProviderAuthenticationResult.failure(error: MockedError.test)
    }
}
