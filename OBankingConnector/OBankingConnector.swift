//
//  OBankingConnector.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public final class OBankingConnector {

    private let configurationParser: ConfigurationParser
    private let deepLinkService: DeepLinkService
    private let externalWebBrowserLauncher: ExternalWebBrowserLauncher
    private let webClient: WebClient

    public init(configuration: OBankingConnectorConfiguration) {
        self.configurationParser = ConfigurationParser(configuration: configuration)

        // Initialize Dependencies
        self.deepLinkService = DefaultDeepLinkService()
        self.externalWebBrowserLauncher = PlatformDependingExternalWebBrowserLauncher()
        self.webClient = AlamofireWebClient()
    }

    public func makeBankServiceProviderAuthenticationProvider() -> BankServiceProviderAuthenticationProvider {
        let oAuth2Processors = DefaultOAuth2BankServiceAuthenticationRequestProcessorFactory()
            .makeProcessor(
                externalWebBrowserLauncher: externalWebBrowserLauncher,
                deepLinkProvider: deepLinkService,
                webClient: webClient
            )

        let authenticationRequestFactoryProvider = ConfigurationBankServiceProviderAuthenticationRequestFactoryProvider(
            configurationParser: configurationParser
        )
        return DefaultBankServiceProviderAuthenticationProvider(
            authenticationRequestFactoryProvider: authenticationRequestFactoryProvider,
            bankServiceProviderRequestProcessors: [
                oAuth2Processors
            ]
        )
    }

    public func makeBankServiceProviderConnector() -> BankServiceProviderConnector {
        return DefaultBankServiceProviderConnector()
    }

    public func makeDeepLinkHandler() -> DeepLinkHandler {
        return self.deepLinkService
    }
}
