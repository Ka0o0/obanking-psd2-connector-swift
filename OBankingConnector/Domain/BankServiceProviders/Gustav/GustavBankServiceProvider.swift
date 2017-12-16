//
//  GustavBankServiceProvider.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 15.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct GustavBankServiceProvider: BankServiceProvider {

    public static let id = "cz.csas.developers.netbanking"

    public let id: String
    public let name: String

    public init() {
        self.id = GustavBankServiceProvider.id
        self.name = "Gustav Netbanking v3"
    }
}
