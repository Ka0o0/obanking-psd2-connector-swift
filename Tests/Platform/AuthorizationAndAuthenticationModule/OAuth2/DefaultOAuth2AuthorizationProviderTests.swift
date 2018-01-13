//
//  DefaultOAuth2AuthorizationProviderTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift

@testable import OBankingConnector

class DefaultOAuth2AuthorizationProviderTests: XCTestCase {

    func test_Authorize() {
        let sut = DefaultOAuth2AuthorizationProvider(
            oAuth2BankServiceConfiguration: OAuth2BankServiceConfigurationMock(),
            oAuth2AuthorizationRequestFactory: OAuth2AuthorizationRequestFactoryMock(),
            oAuth2AuthorizationRequestProcessor: OAuth2AuthorizationRequestProcessorMock()
        )

        do {
            let result = try sut.authorize().toBlocking(timeout: 3).single()
            XCTAssertEqual(result.bankServiceProviderId, "test")
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}

private extension DefaultOAuth2AuthorizationProviderTests {
    class OAuth2AuthorizationRequestProcessorMock: OAuth2AuthorizationRequestProcessor {

        func process(_ request: OAuth2AuthorizationRequest)
            -> Single<AuthorizationResult> {

            return Single.just(
                OAuth2BankServiceConnectionInformation(
                    bankServiceProviderId: "test",
                    accessToken: "accesstoken",
                    tokenType: "testtoken"
                )
            )
        }
    }

    class OAuth2AuthorizationRequestFactoryMock: OAuth2AuthorizationRequestFactory {
        func makeAuthorizationRequest(
            for configuration: OAuth2BankServiceConfiguration
        ) -> OAuth2AuthorizationRequest {
            return OAuth2AuthorizationRequest(
                bankingServiceProviderId: "test",
                authorizationEndpointURL: URL(fileURLWithPath: "asdf"),
                clientId: "client"
            )
        }
    }
}
