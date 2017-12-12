//
//  OAuth2BankServiceProviderAuthenticationRequestProcessor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

final class OAuth2BankServiceProviderAuthenticationRequestProcessor: BankServiceProviderAuthenticationRequestProcessor {

    private let webClient: WebClient
    private let externalWebBrowserLauncher: ExternalWebBrowserLauncher

    init(webClient: WebClient, externalWebBrowserLauncher: ExternalWebBrowserLauncher) {
        self.webClient = webClient
        self.externalWebBrowserLauncher = externalWebBrowserLauncher
    }

    func canProcess(request: BankServiceProviderAuthenticationRequest) -> Bool {
        return request is OAuth2BankServiceProviderAuthenticationRequest
    }

    func authenticate(using request: BankServiceProviderAuthenticationRequest) ->
        Single<BankServiceProviderAuthenticationResult> {

        guard let request = request as? OAuth2BankServiceProviderAuthenticationRequest else {
            return Single.error(BankServiceProviderAuthenticationRequestProcessorError.unsupportedRequest)
        }

        guard let authorizationRequestURL = makeAuthorizationCodeRequestURL(using: request) else {
            return Single.error(BankServiceProviderAuthenticationRequestProcessorError.invalidAuthorizationURL)
        }

        return externalWebBrowserLauncher.open(url: authorizationRequestURL)
            .flatMap { _ -> Single<DataRequest> in
                let parameters = self.makeAccessTokenRequestParameters(using: request, authorizationToken: "")
                return self.webClient.request(
                    .post,
                    request.tokenEndpointURL ?? request.authorizationEndpointURL,
                    parameters: parameters,
                    encoding: URLEncoding.default,
                    headers: nil
                )
                .asSingle()
            }
            .map { _ in
                BankServiceProviderAuthenticationResult.failure(
                    error: BankServiceProviderAuthenticationRequestProcessorError.invalidAuthorizationURL
                )
            }
    }
}

private extension OAuth2BankServiceProviderAuthenticationRequestProcessor {

    func makeAuthorizationCodeRequestURL(using request: OAuth2BankServiceProviderAuthenticationRequest) -> URL? {
        let urlBuilder = URLBuilder(from: request.authorizationEndpointURL)

        urlBuilder.append(queryParameter: ("response_type", "code"))
        urlBuilder.append(queryParameter: ("client_id", request.clientId))

        if let clientSecret = request.clientSecret {
            urlBuilder.append(queryParameter: ("client_secret", clientSecret))
        }

        if let redirectUri = request.redirectURI {
            urlBuilder.append(queryParameter: ("redirect_uri", redirectUri))
        }

        if let scope = request.scope {
            urlBuilder.append(queryParameter: ("scope", scope))
        }

        return urlBuilder.build()
    }

    func makeAccessTokenRequestParameters(
        using request: OAuth2BankServiceProviderAuthenticationRequest,
        authorizationToken: String
    ) -> [String: String] {
        var parameters: [String: String] = [
            "grant_type": "authorization_code",
            "code": authorizationToken,
            "client_id": request.clientId
        ]

        if let redirectUri = request.redirectURI {
            parameters["redirect_uri"] = redirectUri
        }

        if let clientSecret = request.clientSecret {
            parameters["client_secret"] = clientSecret
        }

        return parameters
    }
}
