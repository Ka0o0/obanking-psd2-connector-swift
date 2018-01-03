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

    func toBankAccount() throws -> BankAccount {
        return BankAccount(
            bankId: "coinbase",
            id: id,
            accountNumber: CoinbaseAccountNumber(id: id),
            details: BankAccountDetails(
                balance: try balance.toAmount(),
                type: .current,
                disposeableBalance: nil,
                alias: name
            )
        )
    }
}

enum CoinbaseAccountType: String, Codable {
    case wallet, fiat, multisig, vault, multisig_vault
}
