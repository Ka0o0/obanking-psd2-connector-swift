//
//  BankServiceProviderAuthenticationProviderTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
@testable import OBankingConnector

class BankServiceProviderAuthenticationProviderTests: XCTestCase {

    private class BankServiceProviderAuthenticationProviderMock: BankServiceProviderAuthenticationProvider {
        func authenticate(against bankServiceProvider: BankServiceProvider)
            -> Single<BankServiceProviderAuthenticationResult> {
            fatalError()
        }
    }
}
