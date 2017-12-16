//
//  OAuth2AccessTokenRequestor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

protocol OAuth2AccessTokenRequestor {

    func requestAccessToken(
        for request: OAuth2BankServiceProviderAuthenticationRequest,
        authorizationToken: String
    ) -> Single<OAuth2BankServiceConnectionInformation>
}

final class DefaultOAuth2AccessTokenRequestor: OAuth2AccessTokenRequestor {

    private let webClient: WebClient

    init(webClient: WebClient) {
        self.webClient = webClient
    }

    func requestAccessToken(
        for request: OAuth2BankServiceProviderAuthenticationRequest,
        authorizationToken: String
    ) -> Single<OAuth2BankServiceConnectionInformation> {

        let requestURL = request.tokenEndpointURL ?? request.authorizationEndpointURL
        let parameters = makeParameters(for: request, authorizationToken: authorizationToken)
        return webClient.request(
            .post,
            requestURL,
            parameters: parameters,
            encoding: .urlEncoding,
            headers: request.additionalRequestHeaders
        )
        .asSingle()
        .map { response, data -> OAuth2BankServiceConnectionInformation in

            guard 200..<300 ~= response.statusCode else {
                throw WebClientError.invalidStatusCode
            }

            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(OAuth2BankServiceConnectionInformation.self, from: data)
        }
    }

    private func makeParameters(
        for request: OAuth2BankServiceProviderAuthenticationRequest,
        authorizationToken: String
    ) -> [String: String] {
        var parameters = [String: String]()

        parameters["grant_type"] = "authorization_code"
        parameters["client_id"] = request.clientId
        parameters["code"] = authorizationToken

        if let secret = request.clientSecret {
            parameters["client_secret"] = secret
        }

        if let redirectURI = request.redirectURI {
            parameters["redirect_uri"] = redirectURI
        }

        if let additionalParameters = request.additionalTokenRequestParameters {
            additionalParameters.forEach {
                parameters[$0.key] = $0.value
            }
        }

        return parameters
    }
}
