//
//  DefaultOAuth2AuthorizationTokenExtractorTests.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import OBankingConnector

class DefaultOAuth2AuthorizationTokenExtractorTests: XCTestCase {

    private var authorizationEndpointURL: URL! = URL(string: "https://authorization-server.com/auth")

    func test_ExtractFromURL_NilForInvalidURL() {
        let request = OAuth2AuthorizationRequest(
            bankingServiceProviderId: "test",
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "example"
        )

        let sut = DefaultOAuth2AuthorizationTokenExtractor()

        guard let testURL = URL(string: "example://test") else {
            XCTFail("Shouldn't happen")
            return
        }

        let result = sut.exctract(from: testURL, considering: request, and: nil)
        XCTAssertNil(result)
    }

    func test_ExtractFromURL_ConsidersTokenWhenNoOtherInformationProvided() {
        let request = OAuth2AuthorizationRequest(
            bankingServiceProviderId: "test",
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "example"
        )

        let sut = DefaultOAuth2AuthorizationTokenExtractor()

        guard let testURL = URL(string: "example://test?code=thisonetoken") else {
            XCTFail("Shouldn't happen")
            return
        }

        let result = sut.exctract(from: testURL, considering: request, and: nil)
        XCTAssertEqual(result, "thisonetoken")
    }

    func test_ExtractFromURL_NilWhenStateMismatch() {
        let request = OAuth2AuthorizationRequest(
            bankingServiceProviderId: "test",
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "example"
        )

        let sut = DefaultOAuth2AuthorizationTokenExtractor()

        guard let testURL = URL(string: "example://test?code=thisonetoken") else {
            XCTFail("Shouldn't happen")
            return
        }
        let state = UUID()
        let result = sut.exctract(from: testURL, considering: request, and: state.uuidString)
        XCTAssertNil(result)
    }

    func test_ExtractFromURL_StateMatch() {
        let request = OAuth2AuthorizationRequest(
            bankingServiceProviderId: "test",
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "example"
        )

        let sut = DefaultOAuth2AuthorizationTokenExtractor()
        let state = UUID()

        guard let testURL = URL(string: "example://test?code=thisonetoken&state=" + state.uuidString) else {
            XCTFail("Shouldn't happen")
            return
        }

        let result = sut.exctract(from: testURL, considering: request, and: state.uuidString)
        XCTAssertEqual(result, "thisonetoken")
    }

    func test_ExtractFromStream_FiltersCorrectly() {
        let request = OAuth2AuthorizationRequest(
            bankingServiceProviderId: "test",
            authorizationEndpointURL: authorizationEndpointURL,
            clientId: "example"
        )

        let sut = DefaultOAuth2AuthorizationTokenExtractor()

        guard let testURL = URL(string: "example://test?code=thisonetoken") else {
            XCTFail("Shouldn't happen")
            return
        }

        let replaySubject = ReplaySubject<URL>.create(bufferSize: 1)
        replaySubject.on(.next(testURL))

        do {
            let result = try sut.extract(
                from: replaySubject.asObservable(),
                considering: request,
                and: nil
            ).toBlocking(timeout: 3).first()

            XCTAssertEqual(result, "thisonetoken")
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}
