//
//  GustavGetBankAccountsRequestResponse.swift
//  OBankingConnector
//
//  Created by Kai Takac on 25.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct GustavGetBankAccountsRequestResponse: Codable {

    let accounts: [GustavAccount]
}
