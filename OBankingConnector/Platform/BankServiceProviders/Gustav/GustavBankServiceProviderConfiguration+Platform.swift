//
//  GustavBankServiceProviderConfiguration+Platform.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

/// See https://github.com/Ceskasporitelna/WebAPI/wiki/The-integration-of-the-WebAPI-in-the-CS
extension GustavBankServiceProviderConfiguration: OAuth2BankServiceConfiguration {

    // swiftlint:disable force_unwrapping
    var authorizationEndpointURL: URL {
        return URL(string: "https://www.csas.cz/widp/oauth2/auth")!
    }
    var tokenEndpointURL: URL? {
        return URL(string: "https://www.csas.cz/widp/oauth2/token")!
    }
    // swiftlint:enable force_unwrapping

    var scope: String? {
        return nil
    }

    var additionalAuthorizationRequestParameters: [String: String]? {
        return [
            "access_type": "offline"
        ]
    }

    var additionalTokenRequestParameters: [String: String]? {
        return nil
    }

    var additionalHeaders: [String: String]? {
        return [
            "web-api-key": webAPIKey
        ]
    }

    var bankingRequestTranslator: BankingRequestTranslator {
        guard let baseURL = URL(string: "https://www.csas.cz/webapi/api/v3") else {
            fatalError("Cannot create base URL")
        }

        return GustavBankingRequestTranslator(baseURL: baseURL)
    }

    var authorizationServerCertificate: Data {
        return self.apiServerCertificate
    }

    var tokenServerCertificate: Data {
        return self.apiServerCertificate
    }

    // swiftlint:disable force_try
    var apiServerCertificate: Data {
        guard let certificateURL = OBankingConnector.bundle.url(forResource: "wwwcsascz", withExtension: "crt") else {
            fatalError("Could not read certificate")
        }

        return try! Data(contentsOf: certificateURL)
    }
    // swiftlint:enable force_try
}
