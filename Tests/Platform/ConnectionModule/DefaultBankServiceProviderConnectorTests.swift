//
//  DefaultBankServiceProviderConnectorTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxBlocking
@testable import OBankingConnector

class DefaultBankServiceProviderConnectorTests: XCTestCase {

    private class BankServiceConnectionInformationMock: BankServiceConnectionInformation {
        let bankServiceProviderId: String = "test"
    }

    var sut: DefaultBankServiceProviderConnector!

    override func setUp() {
        super.setUp()

        let supportedBankServicesProvider = SupportedBankServicesProviderMock()
        let connectorConfiguration = OBankingConnectorConfiguration(bankServiceProviderConfigurations: [])

        sut = DefaultBankServiceProviderConnector(
            configurationParser: ConfigurationParser(configuration: connectorConfiguration),
            webClient: WebClientMock(),
            supportedBankServicesProvider: supportedBankServicesProvider
        )
    }

    func test_Connect_ErrorForUnknown() {
        do {
            _ = try sut.connectToBankService(using: BankServiceConnectionInformationMock())
                .toBlocking(timeout: 3)
                .first()
            XCTFail("Should fail")
        } catch let error {
            guard let error = error as? BankServiceProviderConnectorError else {
                XCTFail("Invalid error type")
                return
            }
            XCTAssertEqual(error, .unsupportedConnectionInformation)
        }
    }

    func test_Connect_WorksForOAuth2() {
        do {
            let oAuth2ConnectionInformation = OAuth2BankServiceConnectionInformation(
                bankServiceProviderId: "test",
                accessToken: "asdf",
                tokenType: "bearer"
            )

            let result = try sut.connectToBankService(using: oAuth2ConnectionInformation).toBlocking(timeout: 3).first()

            XCTAssertTrue(result is ConnectedOAuth2BankServiceProvider)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }

}

private extension DefaultBankServiceProviderConnectorTests {

    class SupportedBankServicesProviderMock: SupportedBankServicesProvider {
        let supportedBankServices: [BankServiceProvider] = []

        func bankService(for id: String) -> BankServiceProvider? {
            fatalError()
        }
    }
}
