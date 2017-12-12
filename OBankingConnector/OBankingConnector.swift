//
//  OBankingConnector.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public final class OBankingConnector {

    private let configuration: Configuration
    private let deepLinkService: DeepLinkService

    init(configuration: Configuration) {
        self.configuration = configuration

        // Initialize Dependencies
        self.deepLinkService = DefaultDeepLinkService()
    }

    func makeBankServiceProviderAuthenticationProvider() -> BankServiceProviderAuthenticationProvider {
        fatalError("Not implemented yet")
    }

    func makeBankServiceProviderConnector() -> BankServiceProviderConnector {
        fatalError("Not implemented yet")
    }

    func makeDeepLinkHandler() -> DeepLinkHandler {
        return deepLinkService
    }
}
