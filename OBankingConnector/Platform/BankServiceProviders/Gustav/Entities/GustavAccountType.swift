//
//  GustavAccountType.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

enum GustavAccountType: String, Codable {
    case current = "CURRENT"
    case saving = "SAVING"
    case loan = "LOAN"
}
