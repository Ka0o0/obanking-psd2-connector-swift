//
//  DefaultBankServiceConnectionInformationDecoderTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 21.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class DefaultBankServiceConnectionInformationDecoderTests: XCTestCase {

    func test_Decode_ReturnsNilForInvalidData() {
        let sut = DefaultBankServiceConnectionInformationDecoder()

        guard let data = "".data(using: .utf8) else {
            XCTFail("Should not happen")
            return
        }

        XCTAssertNil(sut.decode(data: data, using: JSONDecoder()))
    }

    func test_Decode_ReturnsOAuthConnectionInformation() {
        let sut = DefaultBankServiceConnectionInformationDecoder()

        let oAuthConnectionInformation = OAuth2BankServiceConnectionInformation(
            bankServiceProviderId: "test",
            accessToken: "asdf",
            tokenType: "bearer"
        )

        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(oAuthConnectionInformation)

            guard let result = sut.decode(
                data: data,
                using: JSONDecoder()
            ) as? OAuth2BankServiceConnectionInformation else {
                XCTFail("Should not be nil")
                return
            }

            XCTAssertEqual(result.accessToken, "asdf")
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}
