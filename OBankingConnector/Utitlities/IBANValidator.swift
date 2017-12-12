//
//  IBANValidator.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class IBANValidator {

    /// Taken from https://stackoverflow.com/a/43810952
    func validate(iban: String) -> Bool {
        var a = iban.utf8.map { $0 }
        while a.count < 4 {
            a.append(0)
        }
        let b = a[4..<a.count] + a[0..<4]
        return b.reduce(0) { (r, u) -> Int in
            let i = Int(u)
            return i > 64 ? (100 * r + i - 55) % 97 : (10 * r + i - 48) % 97
        } == 1
    }
}
