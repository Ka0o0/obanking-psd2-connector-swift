//
//  BankServiceProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public protocol BankServiceProvider {

    var id: String { get }
    var name: String { get }
    var supportedBanks: [Bank] { get }
}
