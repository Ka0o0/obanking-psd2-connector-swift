//
//  CoinbaseAccount.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

struct CoinbaseAccount: Codable {

    let id: String
    let name: String
    let type: CoinbaseAccountType
    let currency: Currency
    let balance: CoinbaseBalance

    func toBankAccount() -> BankAccount {

        return BankAccount(
            bankId: "coinbase",
            id: id,
            accountNumber: CoinbaseAccountNumber(id: id),
            details: nil
        )
    }
}

enum CoinbaseAccountType: String, Codable {
    case wallet, fiat, multisig, vault, multisig_vault
}
