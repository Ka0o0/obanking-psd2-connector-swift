//
//  CoinbaseAPIScope+Platform.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

extension CoinbaseAPIScope {

    var apiScope: String {
        var reading = ""
        reading += "wallet:accounts:read"
        reading += ",wallet:addresses:read"
        reading += ",wallet:buys:read"
        reading += ",wallet:checkouts:read"
        reading += ",wallet:checkouts:read"
        reading += ",wallet:orders:read"
        reading += ",wallet:sells:read"
        reading += ",wallet:transactions:read"
        reading += ",wallet:withdrawals:read"
        reading += ",wallet:user:read"

        switch self {
        case .full:
            var full = "wallet:buys:create"
            full += ",wallet:checkouts:create"
            full += ",wallet:deposits:create"
            full += ",wallet:orders:create"
            full += ",wallet:sells:create"
            full += ",wallet:transactions:send"
            full += ",wallet:transactions:transfer"

            return reading + "," + full
        case .reading:
            return reading
        }
    }
}
