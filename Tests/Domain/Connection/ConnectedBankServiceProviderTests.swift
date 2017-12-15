//
//  ConnectedBankServiceProviderTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
@testable import OBankingConnector

class ConnectedBankServiceProviderTests: XCTestCase {

    private class ConnectedBankServiceProviderMock: ConnectedBankServiceProvider {
        func perform<T: BankingRequest>(request: T) -> Single<BankingRequestResult<T>> {
            fatalError()
        }
    }
}
