//
//  DefaultBankServiceProviderAuthorizationProcessorFactory.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

protocol BankServiceProviderAuthorizationProcessorFactory {
    func makeAuthorizationProcessor(for configuration: BankServiceProviderConfiguration)
        -> BankServiceProviderAuthorizationProcessor?
}

final class DefaultBankServiceProviderAuthorizationProcessorFactory: BankServiceProviderAuthorizationProcessorFactory {

    func makeAuthorizationProcessor(for configuration: BankServiceProviderConfiguration)
        -> BankServiceProviderAuthorizationProcessor? {

        if configuration is OAuth2BankServiceConfiguration {
            return OAuth2BankServiceProviderAuthorizationProcessor()
        }
        return nil
    }
}
