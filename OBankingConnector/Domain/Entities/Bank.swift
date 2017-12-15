//
//  Bank.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct Bank {

    public let id: String
    public let name: String
    public let bankServiceProviderId: String
}

extension Bank: Equatable {
    public static func == (lhs: Bank, rhs: Bank) -> Bool {
        return lhs.id == rhs.id
    }
}
