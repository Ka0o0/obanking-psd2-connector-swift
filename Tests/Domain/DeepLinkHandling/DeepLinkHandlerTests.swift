//
//  DeepLinkHandlerTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class DeepLinkHandlerTests: XCTestCase {

    private class DeepLinkHandlerMock: DeepLinkHandler {

        func handle(deepLink url: URL) {
        }
    }
}
