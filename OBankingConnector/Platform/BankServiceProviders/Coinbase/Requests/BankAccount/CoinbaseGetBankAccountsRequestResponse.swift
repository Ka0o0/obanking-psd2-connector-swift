//
//  CoinbaseGetBankAccountsRequestResponse.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

struct CoinbaseGetBankAccountsRequestResponse: Codable {

    let data: [CoinbaseAccount]
}
