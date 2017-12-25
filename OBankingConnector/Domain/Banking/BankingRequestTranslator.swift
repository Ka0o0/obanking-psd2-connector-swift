//
//  BankingRequestTranslator.swift
//  OBankingConnector
//
//  Created by Kai Takac on 17.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

protocol BankingRequestTranslator {

    func makeHTTPRequest<T: BankingRequest>(from bankingRequest: T) -> HTTPRequest?

    func parseResponse<T: BankingRequest>(of bankingRequest: T, response: Data) throws -> T.Result
}

enum BankingRequestTranslatorError: Error {
    case unsupportedRequestType
}
