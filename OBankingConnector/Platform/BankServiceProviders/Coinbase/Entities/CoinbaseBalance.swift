//
//  CoinbaseBalance.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

struct CoinbaseBalance: Codable {

    let amount: String
    let currency: Currency
}
