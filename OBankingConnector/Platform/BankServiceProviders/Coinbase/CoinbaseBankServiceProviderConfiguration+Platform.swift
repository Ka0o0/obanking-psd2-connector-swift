//
//  CoinbaseBankServiceProviderConfiguration+Platform.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

/// https://developers.coinbase.com/api/v2
extension CoinbaseBankServiceProviderConfiguration: OAuth2BankServiceConfiguration {

    // swiftlint:disable force_unwrapping
    var authorizationEndpointURL: URL {
        return URL(string: "https://www.coinbase.com/oauth/authorize")!
    }
    var tokenEndpointURL: URL? {
        return URL(string: "http://www.coinbase.com/oauth/token")!
    }
    // swiftlint:enable force_unwrapping

    var scope: String? {
        return accessScope.apiScope
    }

    var additionalAuthorizationRequestParameters: [String: String]? {
        return nil
    }

    var additionalTokenRequestParameters: [String: String]? {
        return nil
    }

    var additionalHeaders: [String: String]? {
        return [
            "CB-Version": "2017-08-07"
        ]
    }

    // swiftlint:disable force_try
    var authorizationServerCertificate: Data {
        let bundle = OBankingConnector.bundle
        guard let certificateURL = bundle.url(forResource: "wwwcoinbasecom", withExtension: "crt") else {
            fatalError("Could not read certificate")
        }

        return try! Data(contentsOf: certificateURL)
    }

    var tokenServerCertificate: Data {
        return authorizationServerCertificate
    }

    var apiServerCertificate: Data {
        let bundle = OBankingConnector.bundle
        guard let certificateURL = bundle.url(forResource: "apicoinbasecom", withExtension: "crt") else {
            fatalError("Could not read certificate")
        }

        return try! Data(contentsOf: certificateURL)
    }
    // swiftlint:enable force_try

    var bankingRequestTranslator: BankingRequestTranslator {
        guard let baseURL = URL(string: "https://api.coinbase.com/v2/") else {
            fatalError("Could not create base url")
        }

        return CoinbaseBankingRequestTranslator(baseURL: baseURL, certificate: apiServerCertificate)
    }
}
