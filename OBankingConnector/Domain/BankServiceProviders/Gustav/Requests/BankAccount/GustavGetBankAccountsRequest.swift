//
//  GustavGetBankAccountsRequest.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 23.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavGetBankAccountsRequest {

    private var url: URL

    init(baseURL: URL) {
        url = baseURL.appendingPathComponent("netbanking/my/accounts")
    }

    func makeHTTPRequest(pageSize: Int? = nil, page: Int? = nil) -> HTTPRequest {
        var parameters = [String: String]()

        if let pageSize = pageSize {
            parameters["size"] = String(pageSize)
        }

        if let page = page {
            parameters["page"] = String(page)
        }

        return HTTPRequest(
            method: .get,
            url: url,
            parameters: parameters,
            encoding: .urlEncoding,
            headers: nil
        )
    }

    func parseResponse(_ response: Data) throws -> [BankAccount] {
        let jsonDecoder = JSONDecoder()

        return try jsonDecoder.decode([BankAccount].self, from: response)
    }
}
