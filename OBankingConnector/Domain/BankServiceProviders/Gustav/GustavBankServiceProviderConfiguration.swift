//
//  GustavBankServiceProviderConfiguration.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 15.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct GustavBankServiceProviderConfiguration: OAuth2BankServiceConfiguration {

    public let bankServiceProviderId: String = GustavBankServiceProvider.id

    let clientId: String
    let clientSecret: String?
    let redirectURI: String?

    // swiftlint:disable force_unwrapping
    let authorizationEndpointURL: URL = URL(string: "https://www.csas.cz/widp/oauth2/auth")!
    let tokenEndpointURL: URL? = URL(string: "https://www.csas.cz/widp/oauth2/token")!
    // swiftlint:enable force_unwrapping

    let scope: String? = nil

    init(clientId: String, clientSecret: String, redirectURI: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
}

public struct GustavSandboxBankServiceProviderConfiguration: OAuth2BankServiceConfiguration {

    public let bankServiceProviderId: String = GustavBankServiceProvider.id

    let clientId: String
    let clientSecret: String?
    let redirectURI: String?

    // swiftlint:disable force_unwrapping
    let authorizationEndpointURL: URL = URL(string: "https://www.csast.csas.cz/widp/oauth2/auth")!
    let tokenEndpointURL: URL? = URL(string: "https://www.csast.csas.cz/widp/oauth2/token")!
    // swiftlint:enable force_unwrapping

    let scope: String? = nil

    init(clientId: String, clientSecret: String, redirectURI: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
}
