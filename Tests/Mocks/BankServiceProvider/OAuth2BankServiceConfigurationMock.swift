//
//  OAuth2BankServiceConfigurationMock.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
@testable import OBankingConnector

final class OAuth2BankServiceConfigurationMock: OAuth2BankServiceConfiguration {

    class BankingRequestTranslatorMock: BankingRequestTranslator {
        func makeProcessor<T>(for bankingRequest: T) -> BankingRequestProcessor<T>? where T: BankingRequest {
            return nil
        }
    }

    let authorizationEndpointURL: URL = URL(fileURLWithPath: "test")
    let clientId: String = "client"
    let clientSecret: String? = nil
    let tokenEndpointURL: URL? = nil
    let redirectURI: String? = nil
    let scope: String? = nil
    let bankServiceProvider: BankServiceProvider = BankServiceProviderMock(id: "test", name: "test")
    let additionalAuthorizationRequestParameters: [String: String]? = nil
    let additionalTokenRequestParameters: [String: String]? = nil
    let additionalHeaders: [String: String]? = nil
    let bankingRequestTranslator: BankingRequestTranslator = BankingRequestTranslatorMock()
    var authorizationServerCertificate: Data {
        guard let certificate = "authorizationServerCertificate".data(using: .utf8) else {
            fatalError()
        }
        return certificate
    }
    var tokenServerCertificate: Data {
        guard let certificate = "tokenServerCertificate".data(using: .utf8) else {
            fatalError()
        }
        return certificate
    }
    var apiServerCertificate: Data { fatalError() }
}
