//
//  ConnectedOAuth2BankServiceProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class ConnectedOAuth2BankServiceProvider: ConnectedBankServiceProvider {

    private let oAuth2ConnectionInformation: OAuth2BankServiceConnectionInformation
    private let httpBankingRequestFactory: HTTPBankingRequestFactory
    private let webClient: WebClient
    private let supportedBankServicesProvider: SupportedBankServicesProvider

    init(
        oAuth2ConnectionInformation: OAuth2BankServiceConnectionInformation,
        httpBankingRequestFactory: HTTPBankingRequestFactory,
        webClient: WebClient,
        supportedBankServicesProvider: SupportedBankServicesProvider
    ) {
        self.oAuth2ConnectionInformation = oAuth2ConnectionInformation
        self.httpBankingRequestFactory = httpBankingRequestFactory
        self.webClient = webClient
        self.supportedBankServicesProvider = supportedBankServicesProvider
    }

    func perform<T: BankingRequest>(_ request: T) -> Single<BankingRequestResult<T>> {

        guard let request = makeRequestAndAppendAuthorizationHeader(for: request) else {
            return Single.error(ConnectedBankServiceProviderError.unsupportedRequest)
        }

//        return webClient.request(
//            request.method,
//            request.url,
//            parameters: request.parameters,
//            encoding: request.encoding,
//            headers: request.headers
//        )
    }
}

private extension ConnectedOAuth2BankServiceProvider {

    func makeRequestAndAppendAuthorizationHeader<T: BankingRequest>(for bankingRequest: T) -> HTTPRequest? {

        guard let bankServiceProvider = supportedBankServicesProvider.bankService(
            for: oAuth2ConnectionInformation.bankServiceProviderId
        ) else {
            return nil
        }

        guard let request = httpBankingRequestFactory.makeHTTPRequest(
            for: bankingRequest,
            bankServiceProvider: bankServiceProvider
        ) else {
            return nil
        }

        var headers = request.headers ?? [:]
        headers["Authorization"] = String(format: "bearer %@", oAuth2ConnectionInformation.accessToken)

        return HTTPRequest(
            method: request.method,
            url: request.url,
            parameters: request.parameters,
            encoding: request.encoding,
            headers: headers
        )
    }
}
