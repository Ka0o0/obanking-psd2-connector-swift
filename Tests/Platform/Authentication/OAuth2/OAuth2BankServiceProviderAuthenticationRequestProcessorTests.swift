//
//  OAuth2BankServiceProviderAuthenticationRequestProcessorTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
@testable import OBankingConnector

class OAuth2BankServiceProviderAuthenticationRequestProcessorTests: XCTestCase {

    private var sut: OAuth2BankServiceProviderAuthenticationRequestProcessor!
    private var webClient: WebClientMock!
    private var browserLauncher: ExternalWebBrowserLauncherMock!
    private var oauth2Request: OAuth2BankServiceProviderAuthenticationRequest!

    override func setUp() {
        super.setUp()

        guard let baseURL = URL(string: "https://authorization-server.com/auth") else {
            XCTFail("Should not happen")
            return
        }

        oauth2Request = OAuth2BankServiceProviderAuthenticationRequest(
            authorizationEndpointURL: baseURL,
            clientId: "example",
            clientSecret: "secret",
            redirectURI: "myapp://handleme",
            scope: "create+delete"
        )

        browserLauncher = ExternalWebBrowserLauncherMock()
        webClient = WebClientMock()

        sut = OAuth2BankServiceProviderAuthenticationRequestProcessor(
            webClient: webClient,
            externalWebBrowserLauncher: browserLauncher
        )
    }

    func test_CanProcess_TrueForOAuthRequest() {
        let request = OAuth2BankServiceProviderAuthenticationRequest(
            authorizationEndpointURL: URL(fileURLWithPath: "asdf"),
            clientId: "asdf"
        )
        let result = sut.canProcess(request: request)

        XCTAssertTrue(result)
    }

    func test_CanProcess_FalseForOtherRequest() {
        let result = sut.canProcess(request: BankServiceProviderAuthenticationRequestMock())

        XCTAssertFalse(result)
    }

    func test_Authenticate_FailsForInvalidRequest() {
        do {
            _ = try sut.authenticate(using: BankServiceProviderAuthenticationRequestMock()).toBlocking().single()
            XCTFail("Should fail")
        } catch let error {
            guard let processorError = error as? BankServiceProviderAuthenticationRequestProcessorError else {
                XCTFail("Invalid error type")
                return
            }

            XCTAssertEqual(processorError, BankServiceProviderAuthenticationRequestProcessorError.unsupportedRequest)
        }
    }

    func test_Authenticate_SuccessfulFlow() {
        do {
            _ = try sut.authenticate(using: oauth2Request).toBlocking().single()

            assertCorrectAuthorizationURLWasOpened()
            assertCorrectAccessTokenRequestWasSent()
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}

private extension OAuth2BankServiceProviderAuthenticationRequestProcessorTests {

    class BankServiceProviderAuthenticationRequestMock: BankServiceProviderAuthenticationRequest {
    }

    class ExternalWebBrowserLauncherMock: ExternalWebBrowserLauncher {

        var requestedURL: URL?

        func open(url: URL) -> Single<Void> {
            requestedURL = url
            return Single.just(())
        }
    }

    func assertCorrectAuthorizationURLWasOpened() {
        var expectedURLString = "https://authorization-server.com/auth"
        expectedURLString += "?response_type=code"
        expectedURLString += "&client_id=example"
        expectedURLString += "&client_secret=secret"
        expectedURLString += "&redirect_uri=myapp://handleme"
        expectedURLString += "&scope=create+delete"

        guard let expectedURL = URL(string: expectedURLString) else {
            XCTFail("Should not happen")
            return
        }

        XCTAssertEqual(browserLauncher.requestedURL, expectedURL)
    }

    func assertCorrectAccessTokenRequestWasSent() {
        guard let lastRequest = webClient.lastRequest else {
            XCTFail("Processor must send access token request")
            return
        }

        XCTAssertEqual(lastRequest.method, .post)
    }
}
