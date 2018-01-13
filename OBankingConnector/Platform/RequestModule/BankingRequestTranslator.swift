//
//  BankingRequestTranslator.swift
//  OBankingConnector
//
//  Created by Kai Takac on 17.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

protocol BankingRequestTranslator {

    func makeProcessor<T: BankingRequest>(for bankingRequest: T) -> BankingRequestProcessor<T>?
}

enum BankingRequestTranslatorError: Error {
    case unsupportedRequestType
}
