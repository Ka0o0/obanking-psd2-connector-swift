//
//  BankServiceProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct BankServiceProvider {

    let id: String
    let name: String
}

extension BankServiceProvider: Hashable {
    public var hashValue: Int {
        return id.hashValue
    }

    public static func == (lhs: BankServiceProvider, rhs: BankServiceProvider) -> Bool {
        return lhs.id == rhs.id
    }
}
