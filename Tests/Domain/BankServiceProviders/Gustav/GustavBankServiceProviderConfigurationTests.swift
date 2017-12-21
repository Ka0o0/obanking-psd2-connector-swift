//
//  GustavBankServiceProviderConfigurationTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 21.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
@testable import OBankingConnector

class GustavBankServiceProviderConfigurationTests: XCTestCase {

    func test_Certificates_Readable() {
        let sut = GustavBankServiceProviderConfiguration(
            clientId: "",
            clientSecret: "",
            redirectURI: "",
            webAPIKey: ""
        )

        _ = sut.apiServerCertificate
    }
}
