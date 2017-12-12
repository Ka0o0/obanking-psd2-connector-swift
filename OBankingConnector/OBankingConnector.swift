//
//  OBankingConnector.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public final class OBankingConnector {

    private let configuration: Configuration

    init(configuration: Configuration) {
        self.configuration = configuration
    }

    func makeBankServiceProviderAuthenticationProvider() -> BankServiceProviderAuthenticationProvider {
        fatalError("Not implemented yet")
    }

    func makeBankServiceProviderConnector() -> BankServiceProviderConnector {
        fatalError("Not implemented yet")
    }
}
