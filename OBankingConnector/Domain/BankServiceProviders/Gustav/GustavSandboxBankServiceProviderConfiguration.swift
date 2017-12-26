//
//  GustavSandboxBankServiceProviderConfiguration.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 15.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct GustavSandboxBankServiceProviderConfiguration: BankServiceProviderConfiguration {

    public let bankServiceProvider: BankServiceProvider = GustavBankServiceProvider()

    let clientId: String
    let clientSecret: String?
    let redirectURI: String?
    let webAPIKey: String

    public init(clientId: String, clientSecret: String, redirectURI: String, webAPIKey: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
        self.webAPIKey = webAPIKey
    }
}
