//
//  CoinbaseBankingRequestTranslator.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

final class CoinbaseBankingRequestTranslator: BankingRequestTranslator {

    func makeProcessor<T>(for bankingRequest: T) -> BankingRequestProcessor<T>? where T: BankingRequest {
        fatalError()
    }
}
