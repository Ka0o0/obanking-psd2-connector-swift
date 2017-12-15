//
//  OAuth2BankServiceConfiguration.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

protocol OAuth2BankServiceConfiguration: BankServiceProviderConfiguration {

    var authorizationEndpointURL: URL { get }
    var clientId: String { get }
    var clientSecret: String? { get }
    var tokenEndpointURL: URL? { get }
    var redirectURI: String? { get }
    var scope: String? { get }
}
