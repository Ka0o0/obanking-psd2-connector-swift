//
//  OAuth2BankServiceProviderAuthenticationRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct OAuth2AuthorizationRequest {

    let bankingServiceProviderId: String
    let authorizationEndpointURL: URL
    let clientId: String
    let clientSecret: String?
    let tokenEndpointURL: URL?
    let redirectURI: String?
    let scope: String?
    let additionalAuthorizationRequestParameters: [String: String]?
    let additionalTokenRequestParameters: [String: String]?
    let additionalRequestHeaders: [String: String]?
    let authorizationServerCertificate: Data
    let tokenServerCertificate: Data
}
