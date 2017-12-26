//
//  GustavGetTransactionHistoryRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavGetTransactionHistoryRequest {

    private var baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func makeHTTPRequest(iban: String, pageSize: Int? = nil, page: Int? = nil) -> HTTPRequest {
        var parameters = [String: String]()

        if let pageSize = pageSize {
            parameters["size"] = String(pageSize)
        }

        if let page = page {
            parameters["page"] = String(page)
        }

        let urlPathAppendix = String(format: "netbanking/cz/my/accounts/%@/transactions", iban)

        return HTTPRequest(
            method: .get,
            url: baseURL.appendingPathComponent(urlPathAppendix),
            parameters: parameters,
            encoding: .urlEncoding,
            headers: nil
        )
    }

    func parseResponse(_ data: Data, bankAccount: BankAccount) throws -> TransactionHistory {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom(ISO8601JSONDateDecodingStrategy)
        let apiTransactions = try jsonDecoder.decode(GustavGetTransactionHistoryRequestResponse.self, from: data)
        let transactions: [Transaction] = try apiTransactions.transactions.map {
            try $0.toTransaction(associating: bankAccount)
        }

        return TransactionHistory(date: Date(), transactions: transactions)
    }
}
