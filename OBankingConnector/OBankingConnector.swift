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
    private let supportedBankServicesProvider: SupportedBankServicesProvider

    public init(configuration: OBankingConnectorConfiguration) {
        self.configurationParser = ConfigurationParser(configuration: configuration)

        // Initialize Dependencies
        self.deepLinkService = DefaultDeepLinkService()
        self.externalWebBrowserLauncher = PlatformDependingExternalWebBrowserLauncher()
        self.webClient = AlamofireWebClient()
        self.supportedBankServicesProvider = ConfigurationEnabledSupportedBankServicesProvider(
            configuration: configuration
        )
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
        return DefaultBankServiceProviderConnector(
            configurationParser: configurationParser,
            webClient: webClient,
            supportedBankServicesProvider: supportedBankServicesProvider
        )
    }

    public func makeDeepLinkHandler() -> DeepLinkHandler {
        return self.deepLinkService
    }

    public func makeSupportedBankServicesProvider() -> SupportedBankServicesProvider {
        return self.supportedBankServicesProvider
    }

    public func makeBankServiceConnectionInformationDecoder() -> BankServiceConnectionInformationDecoder {
        return DefaultBankServiceConnectionInformationDecoder()
    }
}
