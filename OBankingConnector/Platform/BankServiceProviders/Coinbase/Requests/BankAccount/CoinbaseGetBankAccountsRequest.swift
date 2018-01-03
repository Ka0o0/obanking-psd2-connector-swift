//
//  CoinbaseGetBankAccountsRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation

final class CoinbaseGetBankAccountsRequest: BankingRequestProcessor<GetBankAccountRequest> {

    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    override func makeHTTPRequest(from bankingRequest: GetBankAccountRequest) throws -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: baseURL.appendingPathComponent("accounts"),
            parameters: nil,
            encoding: .urlEncoding,
            headers: nil
        )
    }

    override func parseResponse(
        of bankingRequest: GetBankAccountRequest,
        response: Data
    ) throws -> [BankAccount] {
        let jsonDecoder = JSONDecoder()

        let result = try jsonDecoder.decode(CoinbaseGetBankAccountsRequestResponse.self, from: response)

        return result.data.map {
            $0.toBankAccount()
        }
    }
}
