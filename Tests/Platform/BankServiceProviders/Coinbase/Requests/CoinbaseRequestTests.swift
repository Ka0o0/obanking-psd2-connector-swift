//
//  CoinbaseRequestTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest

class CoinbaseRequestTests: XCTestCase {

    var baseURL: URL!

    override func setUp() {
        super.setUp()

        baseURL = URL(string: "https://api.coinbase.com/v2/")
    }
}
