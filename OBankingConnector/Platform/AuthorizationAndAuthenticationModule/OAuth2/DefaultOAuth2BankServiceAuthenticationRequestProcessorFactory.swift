//
//  DefaultOAuth2BankServiceAuthenticationRequestProcessorFactory.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class DefaultOAuth2BankServiceAuthenticationRequestProcessorFactory {

    func makeProcessor(
        externalWebBrowserLauncher: ExternalWebBrowserLauncher,
        deepLinkProvider: DeepLinkProvider,
        webClient: WebClient
    ) -> OAuth2BankServiceProviderAuthenticationRequestProcessor {
        return OAuth2BankServiceProviderAuthenticationRequestProcessor(
            externalWebBrowserLauncher: externalWebBrowserLauncher,
            deepLinkProvider: deepLinkProvider,
            authorizationRequestURLBuilder: DefaultOAuth2AuthorizationRequestURLBuilder(),
            authorizationTokenExtractor: DefaultOAuth2AuthorizationTokenExtractor(),
            accessTokenRequestor: DefaultOAuth2AccessTokenRequestor(webClient: webClient)
        )
    }
}
