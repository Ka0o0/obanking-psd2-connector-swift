//
//  Currency.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public enum Currency: String {

    case EUR
    case GBP

    public var name: String {
        switch self {
        case .EUR:
            return "Euro"
        case .GBP:
            return "Great British Pound"
        }
    }
}
