//
//  SepaAccountNumber.swift
//  OBankingConnector
//
//  Created by Kai Takac on 10.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

public struct SepaAccountNumber: AccountNumber, Codable {

    public let iban: String
    public let bic: String

    public init?(iban: String, bic: String) {
        let validator = IBANValidator()
        guard validator.validate(iban: iban) else {
            return nil
        }

        self.iban = iban
        self.bic = bic
    }

    public func equals(other: AccountNumber) -> Bool {
        guard let otherSepaAccountNumber = other as? SepaAccountNumber else {
            return false
        }

        return otherSepaAccountNumber == self
    }
}

extension SepaAccountNumber: Equatable {
    public static func == (lhs: SepaAccountNumber, rhs: SepaAccountNumber) -> Bool {
        return lhs.iban == rhs.iban && lhs.bic == rhs.bic
    }
}
