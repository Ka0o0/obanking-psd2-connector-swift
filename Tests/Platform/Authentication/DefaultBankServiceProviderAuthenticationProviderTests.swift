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

            return Single.just(.success(bankServiceConnectionInformation: BankServiceConnectionInformationMock()))
        }
    }
    // swiftlint:enable colon

    func test_Init_TakesSupportedBankServiceProviderMapAndProcessors() {
        let bankServiceToRequestFactory: [BankServiceProvider: BankServiceProviderAuthenticationRequestFactory] = [
            BankServiceProvider(id: "test", name: ""): BankServiceProviderAuthenticationRequestFactoryMock()
        ]

        let processors = [BankServiceProviderAuthenticationRequestMockProcessor()]

        _ = DefaultBankServiceProviderAuthenticationProvider(
            supportedBankServiceProviderMap: bankServiceToRequestFactory,
            bankServiceProviderRequestProcessors: processors
        )
    }

    func test_Authenticate_FailsForInvalidBankService() {
        let sut = DefaultBankServiceProviderAuthenticationProvider(
            supportedBankServiceProviderMap: [:],
            bankServiceProviderRequestProcessors: []
        )

        do {
            _ = try sut.authenticate(against: BankServiceProvider(id: "test", name: "")).toBlocking().single()
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
        let bankServiceToRequestFactory: [BankServiceProvider: BankServiceProviderAuthenticationRequestFactory] = [
            BankServiceProvider(id: "test", name: ""): BankServiceProviderAuthenticationRequestFactoryMock()
        ]
        let sut = DefaultBankServiceProviderAuthenticationProvider(
            supportedBankServiceProviderMap: bankServiceToRequestFactory,
            bankServiceProviderRequestProcessors: []
        )

        do {
            _ = try sut.authenticate(against: BankServiceProvider(id: "test", name: "")).toBlocking().single()
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
        let bankServiceToRequestFactory: [BankServiceProvider: BankServiceProviderAuthenticationRequestFactory] = [
            BankServiceProvider(id: "test", name: ""): BankServiceProviderAuthenticationRequestFactoryMock()
        ]

        let processors = [BankServiceProviderAuthenticationRequestMockProcessor()]

        let sut = DefaultBankServiceProviderAuthenticationProvider(
            supportedBankServiceProviderMap: bankServiceToRequestFactory,
            bankServiceProviderRequestProcessors: processors
        )

        do {
            guard let result = try sut.authenticate(against: BankServiceProvider(id: "test", name: ""))
                .toBlocking()
                .single() else {
                XCTFail("Should not be nil")
                return
            }
            switch result {
            case .failure:
                XCTFail("We shouldn't be here")
            case .success(let bankServiceConnectionInformation):
                XCTAssertTrue(bankServiceConnectionInformation is BankServiceConnectionInformationMock)
            }
        } catch let error {
            XCTFail(String(describing: error))
        }
    }
}
