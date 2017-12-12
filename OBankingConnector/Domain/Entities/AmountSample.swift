//
//  AmountSample.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct AmountSample {

    public let amount: Amount
    public let date: Date

    public init(amount: Amount, date: Date) {
        self.amount = amount
        self.date = date
    }
}

extension AmountSample: Equatable {
    public static func ==(lhs: AmountSample, rhs: AmountSample) -> Bool {
        return lhs.amount == rhs.amount &&
            lhs.date == rhs.date
    }
}
