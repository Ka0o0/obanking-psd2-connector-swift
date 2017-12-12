//
//  URLBuilderTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class URLBuilderTests: XCTestCase {

    func test_Build_BuildsProperURL() {
        guard let baseURL = URL(string: "https://duckduckgo.com") else {
            XCTFail("Should not happen")
            return
        }

        let builder = URLBuilder(from: baseURL)
        builder.append(queryParameter: ("t", "ffab"))
        builder.append(queryParameter: ("q", "test"))

        guard let expectedURL = URL(string: "https://duckduckgo.com?t=ffab&q=test") else {
            XCTFail("Should not happen")
            return
        }

        XCTAssertEqual(builder.build(), expectedURL)
    }

    func test_Build_BuildsProperURLWithExistingQueryParameters() {
        guard let baseURL = URL(string: "https://duckduckgo.com?t=ffab") else {
            XCTFail("Should not happen")
            return
        }

        let builder = URLBuilder(from: baseURL)
        builder.append(queryParameter: ("q", "test"))

        guard let expectedURL = URL(string: "https://duckduckgo.com?t=ffab&q=test") else {
            XCTFail("Should not happen")
            return
        }

        XCTAssertEqual(builder.build(), expectedURL)
    }

    func test_Build_EscapesInvalidCharacters() {
        guard let baseURL = URL(string: "https://duckduckgo.com?t=ffab") else {
            XCTFail("Should not happen")
            return
        }

        let builder = URLBuilder(from: baseURL)
        builder.append(queryParameter: ("q", "te st"))

        guard let expectedURL = URL(string: "https://duckduckgo.com?t=ffab&q=te%20st") else {
            XCTFail("Should not happen")
            return
        }

        XCTAssertEqual(builder.build(), expectedURL)
    }
}
