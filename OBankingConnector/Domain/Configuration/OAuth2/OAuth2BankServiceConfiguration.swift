//
//  OAuth2BankServiceConfiguration.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct OAuth2BankServiceConfiguration: BankServiceProviderConfiguration {

    public let bankServiceProviderId: String

    let clientId: String
    let clientSecret: String?
}
