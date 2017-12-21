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
    private var browserLauncher: ExternalWebBrowserLauncherMock!
    private var oauth2Request: OAuth2BankServiceProviderAuthenticationRequest!
    private var deepLinkProvider: DeepLinkProviderMock!
    private var tokenExtractorMock: OAuth2AuthorizationTokenExtractorMock!
    private var accessTokenRequestorMock: OAuth2AccessTokenRequestorMock!
    private let authorizationRequestURLBuilder = OAuth2AuthorizationRequestURLBuilderMock()

    override func setUp() {
        super.setUp()

        guard let baseURL = URL(string: "https://authorization-server.com/auth") else {
            XCTFail("Should not happen")
            return
        }

        guard let tokenURL = URL(string: "https://authorization-server.com/token") else {
            XCTFail("Should not happen")
            return
        }

        oauth2Request = OAuth2BankServiceProviderAuthenticationRequest(
            bankingServiceProviderId: "test",
            authorizationEndpointURL: baseURL,
            clientId: "example",
            clientSecret: "secret",
            tokenEndpointURL: tokenURL,
            redirectURI: "myapp://handleme",
            scope: "create+delete"
        )

        browserLauncher = ExternalWebBrowserLauncherMock()
        deepLinkProvider = DeepLinkProviderMock()
        tokenExtractorMock = OAuth2AuthorizationTokenExtractorMock()
        accessTokenRequestorMock = OAuth2AccessTokenRequestorMock()

        sut = OAuth2BankServiceProviderAuthenticationRequestProcessor(
            externalWebBrowserLauncher: browserLauncher,
            deepLinkProvider: deepLinkProvider,
            authorizationRequestURLBuilder: authorizationRequestURLBuilder,
            authorizationTokenExtractor: tokenExtractorMock,
            accessTokenRequestor: accessTokenRequestorMock
        )
    }

    func test_CanProcess_TrueForOAuthRequest() {
        let request = OAuth2BankServiceProviderAuthenticationRequest(
            bankingServiceProviderId: "test",
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

            let authorizationRequestResponseString = "myapp://handleme?token=thisoneauthtoken"
            guard let authorizationRequestResponseURL = URL(string: authorizationRequestResponseString) else {
                XCTFail("Shouldn't happen")
                return
            }

            deepLinkProvider.nextRequestResponse = authorizationRequestResponseURL
            tokenExtractorMock.nextToken = "mockedAuthToken"
            accessTokenRequestorMock.nextConnectionInformation =
                OAuth2BankServiceConnectionInformation(
                    bankServiceProviderId: "test",
                    accessToken: "mockedAccessToken",
                    tokenType: "bearer"
                )

            guard let result = try sut.authenticate(using: oauth2Request).toBlocking().first() else {
                XCTFail("Result must not be nil")
                return
            }

            assertProvidesProperRequestAndState()
            assertCorrectAuthorizationURLWasOpened()

            guard let oAuthResult = result as? OAuth2BankServiceConnectionInformation else {
                XCTFail("Should not happen")
                return
            }

            XCTAssertEqual(oAuthResult.accessToken, "mockedAccessToken")
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

    func assertProvidesProperRequestAndState() {
        XCTAssertNotNil(authorizationRequestURLBuilder.lastState)
        XCTAssertNotNil(authorizationRequestURLBuilder.lastRequest)
    }

    func assertCorrectAuthorizationURLWasOpened() {
        XCTAssertEqual(browserLauncher.requestedURL, authorizationRequestURLBuilder.requestURL)
    }
}
