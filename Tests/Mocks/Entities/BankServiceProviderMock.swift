//
//  BankServiceProviderMock.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 15.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
@testable import OBankingConnector

struct BankServiceProviderMock: BankServiceProvider {

    let id: String
    let name: String
    let supportedBanks: [Bank] = []

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
