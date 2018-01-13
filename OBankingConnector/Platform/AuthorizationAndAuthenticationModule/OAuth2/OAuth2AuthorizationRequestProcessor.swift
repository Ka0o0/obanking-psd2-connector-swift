//
//  OAuth2AuthorizationRequestProcessor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol OAuth2AuthorizationRequestProcessor {
    func process(_ request: OAuth2AuthorizationRequest)
        -> Single<AuthorizationResult>
}

final class DefaultOAuth2AuthorizationRequestProcessor: OAuth2AuthorizationRequestProcessor {

    private let externalWebBrowserLauncher: ExternalWebBrowserLauncher
    private let deepLinkProvider: DeepLinkProvider
    private let authorizationRequestURLBuilder: OAuth2AuthorizationRequestURLBuilder
    private let authorizationTokenExtractor: OAuth2AuthorizationTokenExtractor
    private let accessTokenRequestor: OAuth2AccessTokenRequestor

    init(
        externalWebBrowserLauncher: ExternalWebBrowserLauncher,
        deepLinkProvider: DeepLinkProvider,
        authorizationRequestURLBuilder: OAuth2AuthorizationRequestURLBuilder,
        authorizationTokenExtractor: OAuth2AuthorizationTokenExtractor,
        accessTokenRequestor: OAuth2AccessTokenRequestor
    ) {
        self.externalWebBrowserLauncher = externalWebBrowserLauncher
        self.deepLinkProvider = deepLinkProvider
        self.authorizationRequestURLBuilder = authorizationRequestURLBuilder
        self.authorizationTokenExtractor = authorizationTokenExtractor
        self.accessTokenRequestor = accessTokenRequestor
    }

    func process(_ request: OAuth2AuthorizationRequest)
        -> Single<AuthorizationResult> {

        let state = UUID()
        guard let authorizationRequestURL =
            authorizationRequestURLBuilder.makeAuthorizationCodeRequestURL(for: request, adding: state) else {
            return Single.error(OAuth2AuthorizationError.invalidAuthorizationURL)
        }

        return self.externalWebBrowserLauncher.open(url: authorizationRequestURL)
            .flatMap { _ -> Single<String> in
                self.authorizationTokenExtractor.extract(
                    from: self.deepLinkProvider.deepLinkTriggered,
                    considering: request,
                    and: state.uuidString
                )
                .take(1)
                .asSingle()
            }
            .flatMap { authorizationToken -> Single<AuthorizationResult> in
                self.accessTokenRequestor.requestAccessToken(
                    for: request,
                    authorizationToken: authorizationToken
                )
                .map { $0 as BankServiceConnectionInformation }
            }
    }
}
