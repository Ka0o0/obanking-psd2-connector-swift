//
//  SupportedBankServicesProviderTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class SupportedBankServicesProviderTests: XCTestCase {

    private class SupportedBankServicesProviderMock: SupportedBankServicesProvider {

        let supportedBankServices = [BankServiceProvider]()

        func bankService(for id: String) -> BankServiceProvider? {
            fatalError()
        }
    }
}
