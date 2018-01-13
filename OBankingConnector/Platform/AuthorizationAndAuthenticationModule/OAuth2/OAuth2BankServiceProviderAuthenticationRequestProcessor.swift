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

    func canProcess(request: BankServiceProviderAuthenticationRequest) -> Bool {
        return request is OAuth2BankServiceProviderAuthenticationRequest
    }

    func authenticate(using request: BankServiceProviderAuthenticationRequest) ->
        Single<BankServiceProviderAuthenticationResult> {

        guard let request = request as? OAuth2BankServiceProviderAuthenticationRequest else {
            return Single.error(BankServiceProviderAuthenticationRequestProcessorError.unsupportedRequest)
        }

        let state = UUID()
        guard let authorizationRequestURL =
            authorizationRequestURLBuilder.makeAuthorizationCodeRequestURL(for: request, adding: state) else {
            return Single.error(BankServiceProviderAuthenticationRequestProcessorError.invalidAuthorizationURL)
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
            .flatMap { authorizationToken -> Single<BankServiceProviderAuthenticationResult> in
                self.accessTokenRequestor.requestAccessToken(
                    for: request,
                    authorizationToken: authorizationToken
                )
                .map { $0 as BankServiceConnectionInformation }
            }
    }
}
