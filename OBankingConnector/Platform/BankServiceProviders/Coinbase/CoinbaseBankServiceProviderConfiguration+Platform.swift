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
        return URL(string: "https://www.csas.cz/widp/oauth2/auth")!
    }
    var tokenEndpointURL: URL? {
        return URL(string: "https://www.csas.cz/widp/oauth2/token")!
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
        return nil
    }

    var authorizationServerCertificate: Data {
        return apiServerCertificate
    }

    var tokenServerCertificate: Data {
        return apiServerCertificate
    }

    // swiftlint:disable force_try
    var apiServerCertificate: Data {
        let bundle = OBankingConnector.bundle
        guard let certificateURL = bundle.url(forResource: "wwwcoinbasecom", withExtension: "crt") else {
            fatalError("Could not read certificate")
        }

        return try! Data(contentsOf: certificateURL)
    }
    // swiftlint:enable force_try

    var bankingRequestTranslator: BankingRequestTranslator {
        return CoinbaseBankingRequestTranslator()
    }
}
