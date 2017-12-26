//
//  GustavAccount.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct GustavAccount: Codable {
    let id: String
    let accountno: GustavAccountno
    let alias: String?
    let balance: GustavBalance
    let disposable: GustavBalance?
    let type: GustavAccountType
    let subtype: String
}
