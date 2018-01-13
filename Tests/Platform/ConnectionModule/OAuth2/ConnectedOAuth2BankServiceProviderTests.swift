//
//  ConnectedOAuth2BankServiceProviderTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 17.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
@testable import OBankingConnector

class ConnectedOAuth2BankServiceProviderTests: XCTestCase {

    var webClient: WebClientMock!

    override func setUp() {
        super.setUp()

        webClient = WebClientMock()
    }

    func test_Perform_PerformsProperRequest() {
        let oAuth2ConnectionInformation = OAuth2BankServiceConnectionInformation(
            bankServiceProviderId: "test",
            accessToken: "asdf",
            tokenType: "bearer"
        )

        let bankingRequestTranslator = BankingRequestTranslatorMock()

        let configuration = OBankingConnectorConfiguration(
            bankServiceProviderConfigurations: [
                BankServiceProviderConfigurationMock(bankingRequestTranslator: bankingRequestTranslator)
            ]
        )
        let configurationParser = ConfigurationParser(configuration: configuration)

        let sut = ConnectedOAuth2BankServiceProvider(
            oAuth2ConnectionInformation: oAuth2ConnectionInformation,
            configurationParser: configurationParser,
            webClient: webClient,
            supportedBankServicesProvider: SupportedBankServicesProviderMock()
        )

        do {
            let result = try sut.perform(RequestMock()).toBlocking(timeout: 3).single()

            XCTAssertTrue((result as Any) is RequestMock.Result)
            XCTAssertTrue(bankingRequestTranslator.processor.wasCalled)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}

private extension ConnectedOAuth2BankServiceProviderTests {

    class RequestMock: BankingRequest {
        // swiftlint:disable nesting
        struct Result {
        }
        // swiftlint: enable nesting
    }

    class SupportedBankServicesProviderMock: SupportedBankServicesProvider {
        var supportedBankServices: [BankServiceProvider] = [BankServiceProviderMock(id: "test", name: "test")]

        func bankService(for id: String) -> BankServiceProvider? {
            let filtered = supportedBankServices.filter {
                $0.id == id
            }

            return filtered.first
        }
    }

    enum BankingRequestTranslatorMockError: Error {
        case invalidRequestType
    }

    class BankingRequestProcessorMock: BankingRequestProcessor<RequestMock> {

        var wasCalled = false

        override func perform(
            request: ConnectedOAuth2BankServiceProviderTests.RequestMock,
            using webClient: WebClient
        ) -> Single<ConnectedOAuth2BankServiceProviderTests.RequestMock.Result> {
            wasCalled = true
            return Single.just(ConnectedOAuth2BankServiceProviderTests.RequestMock.Result())
        }
    }

    class BankingRequestTranslatorMock: BankingRequestTranslator {

        let processor = BankingRequestProcessorMock()

        func makeProcessor<T>(for bankingRequest: T) -> BankingRequestProcessor<T>? where T: BankingRequest {
            return processor as? BankingRequestProcessor<T>
        }
    }

    class BankServiceProviderConfigurationMock: OAuth2BankServiceConfiguration {

        let authorizationEndpointURL: URL = URL(fileURLWithPath: "test")
        let clientId: String = ""
        let clientSecret: String? = nil
        let tokenEndpointURL: URL? = nil
        let redirectURI: String? = nil
        let scope: String? = nil
        let additionalAuthorizationRequestParameters: [String: String]? = nil
        let additionalTokenRequestParameters: [String: String]? = nil
        let additionalHeaders: [String: String]? = nil
        let bankingRequestTranslator: BankingRequestTranslator
        let bankServiceProvider: BankServiceProvider = BankServiceProviderMock(id: "test", name: "test")
        var authorizationServerCertificate: Data { fatalError() }
        var tokenServerCertificate: Data { fatalError() }
        var apiServerCertificate: Data {
            guard let certificate = "apiServerCertificate".data(using: .utf8) else {
                fatalError()
            }
            return certificate
        }

        init(bankingRequestTranslator: BankingRequestTranslator) {
            self.bankingRequestTranslator = bankingRequestTranslator
        }
    }
}
