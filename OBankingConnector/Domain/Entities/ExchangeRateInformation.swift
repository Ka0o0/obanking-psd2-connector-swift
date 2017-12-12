//
//  ExchangeRateInformation.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct ExchangeRateInformation {

    public let source: Currency
    public let target: Currency
    public let rate: Decimal
    public let date: Date
}

extension ExchangeRateInformation: Equatable {
    public static func == (lhs: ExchangeRateInformation, rhs: ExchangeRateInformation) -> Bool {
        return lhs.source == rhs.source &&
            lhs.target == rhs.target &&
            lhs.rate == rhs.rate
    }
}
