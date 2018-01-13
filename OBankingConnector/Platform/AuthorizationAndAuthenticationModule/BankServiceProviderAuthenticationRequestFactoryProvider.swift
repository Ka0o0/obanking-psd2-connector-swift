//
//  BankServiceProviderAuthenticationRequestFactoryProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

protocol BankServiceProviderAuthenticationRequestFactoryProvider {

    func makeAuthenticationRequestFactory(for bankServiceProvider: BankServiceProvider)
        -> BankServiceProviderAuthenticationRequestFactory?
}
