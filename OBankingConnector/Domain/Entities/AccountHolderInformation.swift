//
//  AccountHolderInformation.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct AccountHolderInformation {

    public let fullName: String
    public let firstName: String?
    public let lastName: String?

    public init(fullName: String, firstName: String? = nil, lastName: String? = nil) {
        self.fullName = fullName
        self.firstName = firstName
        self.lastName = lastName
    }
}
