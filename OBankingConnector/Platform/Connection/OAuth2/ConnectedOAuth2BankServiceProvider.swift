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
    private let configurationParser: ConfigurationParser
    private let webClient: WebClient
    private let supportedBankServicesProvider: SupportedBankServicesProvider

    init(
        oAuth2ConnectionInformation: OAuth2BankServiceConnectionInformation,
        configurationParser: ConfigurationParser,
        webClient: WebClient,
        supportedBankServicesProvider: SupportedBankServicesProvider
    ) {
        self.oAuth2ConnectionInformation = oAuth2ConnectionInformation
        self.configurationParser = configurationParser
        self.webClient = webClient
        self.supportedBankServicesProvider = supportedBankServicesProvider
    }

    func perform<T: BankingRequest>(_ request: T) -> Single<T.Result> {

        guard let configuration = getConfiguration() else {
            return Single.error(ConnectedBankServiceProviderError.unsupportedRequest)
        }

        guard let translator = configuration.bankingRequestTranslator.makeProcessor(for: request) else {
            return Single.error(ConnectedBankServiceProviderError.unsupportedRequest)
        }

        let httpRequest = makeRequestAndAppendAuthorizationHeader(for: request, using: translator)

        return webClient.request(
            httpRequest.method,
            httpRequest.url,
            parameters: httpRequest.parameters,
            encoding: httpRequest.encoding,
            headers: httpRequest.headers,
            certificate: configuration.apiServerCertificate
        )
        .map { response, data -> T.Result in
            guard 200..<300 ~= response.statusCode else {
                throw WebClientError.invalidStatusCode
            }

            return try translator.parseResponse(of: request, response: data)
        }
        .asSingle()
    }
}

private extension ConnectedOAuth2BankServiceProvider {

    func getConfiguration() -> OAuth2BankServiceConfiguration? {
        guard let bankServiceProvider = supportedBankServicesProvider.bankService(
            for: oAuth2ConnectionInformation.bankServiceProviderId
            ) else {
                return nil
        }

        return configurationParser.getBankServiceConfiguration(for: bankServiceProvider)
            as? OAuth2BankServiceConfiguration
    }

    func makeRequestAndAppendAuthorizationHeader<T>(
        for bankingRequest: T,
        using translator: BankingRequestProcessor<T>
    ) -> HTTPRequest {

        let request = translator.makeHTTPRequest(from: bankingRequest)
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
