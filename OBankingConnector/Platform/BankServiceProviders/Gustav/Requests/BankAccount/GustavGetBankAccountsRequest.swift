//
//  GustavGetBankAccountsRequest.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 23.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavGetBankAccountsRequest: BankingRequestProcessor<GetBankAccountRequest> {

    private var url: URL

    init(baseURL: URL) {
        url = baseURL.appendingPathComponent("netbanking/my/accounts")
    }

    override func makeHTTPRequest(from bankingRequest: GetBankAccountRequest) -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: url,
            parameters: nil,
            encoding: .urlEncoding,
            headers: nil
        )
    }

    override func parseResponse(of bankingRequest: GetBankAccountRequest, response: Data) throws -> [BankAccount] {
        let jsonDecoder = JSONDecoder()
        let apiResponse = try jsonDecoder.decode(GustavGetBankAccountsRequestResponse.self, from: response)

        let bankAccounts: [BankAccount] = try apiResponse.accounts.map {
            try $0.toBankAccount()
        }

        return bankAccounts
    }
}

enum GustavGetBankAccountsRequestParseError: Error {
    case unknownCurrency
    case unknownAccountType
    case invalidSepaAccountNumber
}
