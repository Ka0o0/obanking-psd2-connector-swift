//
//  BankingRequestProcessor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

class BankingRequestProcessor<T> where T: BankingRequest {

    func makeHTTPRequest(from bankingRequest: T) -> HTTPRequest {
        fatalError("Not implemented")
    }

    func parseResponse(of bankingRequest: T, response: Data) throws -> T.Result {
        fatalError("Not implemented")
    }
}
