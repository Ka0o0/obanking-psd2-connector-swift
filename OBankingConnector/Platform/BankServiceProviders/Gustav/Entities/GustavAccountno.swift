//
//  GustavAccountno.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct GustavAccountno: Codable {

    private enum CodingKeys: String, CodingKey {
        case iban = "cz-iban"
        case bic = "cz-bic"
    }

    let iban: String
    let bic: String
}
