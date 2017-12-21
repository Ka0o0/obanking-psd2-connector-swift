//
//  ConnectedOAuth2BankServiceProviderTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 17.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
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

        let expectedURL = URL(fileURLWithPath: "examplerequest")

        let bankingRequestTranslator = BankingRequestTranslatorMock()
        bankingRequestTranslator.nextRequest = HTTPRequest(
            method: .put,
            url: expectedURL,
            parameters: [:],
            encoding: .json,
            headers: nil
        )

        webClient.responseData = "".data(using: .utf8)

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
            _ = try sut.perform(RequestMock()).toBlocking().first()

            guard let request = webClient.lastRequest else {
                XCTFail("Request must not be null")
                return
            }

            if let headers = request.headers {
                XCTAssertEqual(headers, ["Authorization": "bearer asdf"])
            } else {
                XCTFail("Headers must be set")
            }
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
        var supportedBankServices: [BankServiceProvider] = [BankServiceProviderMock()]

        func bankService(for id: String) -> BankServiceProvider? {
            let filtered = supportedBankServices.filter {
                $0.id == id
            }

            return filtered.first
        }
    }

    class BankServiceProviderMock: BankServiceProvider {
        let id = "test"
        let name = "test"
    }

    enum BankingRequestTranslatorMockError: Error {
        case invalidRequestType
    }

    class BankingRequestTranslatorMock: BankingRequestTranslator {

        var nextRequest: HTTPRequest?

        func makeHTTPRequest<T>(from bankingRequest: T) -> HTTPRequest? where T: BankingRequest {
            return nextRequest
        }

        func parseResponse<T>(of bankingRequest: T, response: Data) throws -> T.Result where T: BankingRequest {
            guard let result = RequestMock.Result() as? T.Result else {
                throw BankingRequestTranslatorMockError.invalidRequestType
            }
            return result
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
        let bankServiceProvider: BankServiceProvider = BankServiceProviderMock()
        var authorizationServerCertificate: Data { fatalError() }
        var tokenServerCertificate: Data { fatalError() }
        var apiServerCertificate: Data { fatalError() }

        init(bankingRequestTranslator: BankingRequestTranslator) {
            self.bankingRequestTranslator = bankingRequestTranslator
        }
    }
}
