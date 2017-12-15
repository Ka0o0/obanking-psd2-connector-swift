//
//  DefaultBankServiceProviderAuthenticationProviderTests.swift
//  OBankingConnectorTests
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import OBankingConnector

// swiftlint:disable colon
class DefaultBankServiceProviderAuthenticationProviderTests: XCTestCase {

    private class BankServiceProviderAuthenticationRequestMock: BankServiceProviderAuthenticationRequest {
    }

    private class BankServiceProviderAuthenticationRequestFactoryMock: BankServiceProviderAuthenticationRequestFactory {

        func makeBankServiceProviderAuthenticationRequest() -> BankServiceProviderAuthenticationRequest {
            return BankServiceProviderAuthenticationRequestMock()
        }
    }

    private class BankServiceConnectionInformationMock: BankServiceConnectionInformation {
    }

    private class BankServiceProviderAuthenticationRequestFactoryProviderMock:
        BankServiceProviderAuthenticationRequestFactoryProvider {

        func makeAuthenticationRequestFactory(for bankServiceProvider: BankServiceProvider)
            -> BankServiceProviderAuthenticationRequestFactory? {
            guard bankServiceProvider.id == "test" else {
                return nil
            }
            return BankServiceProviderAuthenticationRequestFactoryMock()
        }
    }

    // swiftlint:disable colon
    private class BankServiceProviderAuthenticationRequestMockProcessor:
        BankServiceProviderAuthenticationRequestProcessor {

        func canProcess(request: BankServiceProviderAuthenticationRequest) -> Bool {
            return request is BankServiceProviderAuthenticationRequestMock
        }

        func authenticate(using request: BankServiceProviderAuthenticationRequest) ->
            Single<BankServiceProviderAuthenticationResult> {

            guard canProcess(request: request) else {
                fatalError("We should never come here")
            }

            return Single.just(BankServiceConnectionInformationMock())
        }
    }
    // swiftlint:enable colon

    func test_Authenticate_FailsForInvalidBankService() {
        let factoryProvider = BankServiceProviderAuthenticationRequestFactoryProviderMock()

        let sut = DefaultBankServiceProviderAuthenticationProvider(
            authenticationRequestFactoryProvider: factoryProvider,
            bankServiceProviderRequestProcessors: []
        )

        do {
            _ = try sut.authenticate(against: BankServiceProviderMock(id: "aaa", name: "")).toBlocking().single()
            XCTFail("Shouldn't come here")
        } catch let error {
            guard let providerError = error as? BankServiceProviderAuthenticationProviderError else {
                XCTFail("Invalid error type")
                return
            }

            XCTAssertEqual(providerError, .unsupportedBankServiceProvider)
        }
    }

    func test_Authenticate_FailsForMissingProcessor() {
        let factoryProvider = BankServiceProviderAuthenticationRequestFactoryProviderMock()

        let sut = DefaultBankServiceProviderAuthenticationProvider(
            authenticationRequestFactoryProvider: factoryProvider,
            bankServiceProviderRequestProcessors: []
        )

        do {
            _ = try sut.authenticate(against: BankServiceProviderMock(id: "test", name: "")).toBlocking().single()
            XCTFail("Shouldn't come here")
        } catch let error {
            guard let providerError = error as? BankServiceProviderAuthenticationProviderError else {
                XCTFail("Invalid error type")
                return
            }

            XCTAssertEqual(providerError, .noProperProcessorFound)
        }
    }

    func test_Authenticate_Success() {
        let processors = [BankServiceProviderAuthenticationRequestMockProcessor()]
        let factoryProvider = BankServiceProviderAuthenticationRequestFactoryProviderMock()

        let sut = DefaultBankServiceProviderAuthenticationProvider(
            authenticationRequestFactoryProvider: factoryProvider,
            bankServiceProviderRequestProcessors: processors
        )

        do {
            guard let result = try sut.authenticate(against: BankServiceProviderMock(id: "test", name: ""))
                .toBlocking()
                .single() else {
                XCTFail("Should not be nil")
                return
            }

            XCTAssertTrue(result is BankServiceConnectionInformationMock)
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}

// swiftlint:enable colon
