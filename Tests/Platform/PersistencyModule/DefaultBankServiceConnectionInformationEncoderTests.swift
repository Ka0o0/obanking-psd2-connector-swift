//
//  DefaultBankServiceConnectionInformationEncoderTests.swift
//  OBankingConnectorTests-iOS
//
//  Created by Kai Takac on 29.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class DefaultBankServiceConnectionInformationEncoderTests: XCTestCase {

    func test_Encode_CanEncodeOAuth2ConnectionInformation() {
        let oAuth2ConnectionInformation = OAuth2BankServiceConnectionInformation(
            bankServiceProviderId: "",
            accessToken: "",
            tokenType: ""
        )

        let sut = DefaultBankServiceConnectionInformationEncoder()

        let data = sut.encode(connectionInformation: oAuth2ConnectionInformation, using: JSONEncoder())

        XCTAssertNotNil(data)
    }

}
