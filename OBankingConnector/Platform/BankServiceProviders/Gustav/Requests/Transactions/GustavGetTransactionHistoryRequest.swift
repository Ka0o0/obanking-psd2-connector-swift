//
//  GustavGetTransactionHistoryRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavGetTransactionHistoryRequest: BankingRequestProcessor<GetTransactionHistoryRequest> {

    private var baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    override func makeHTTPRequest(from bankingRequest: GetTransactionHistoryRequest) throws -> HTTPRequest {
        guard let sepaAccountNumber = bankingRequest.bankAccount.accountNumber as? SepaAccountNumber else {
            throw GustavRequestProcessorError.unsupportedAccount
        }

        let urlPathAppendix = String(format: "netbanking/cz/my/accounts/%@/transactions", sepaAccountNumber.iban)

        return HTTPRequest(
            method: .get,
            url: baseURL.appendingPathComponent(urlPathAppendix),
            parameters: nil,
            encoding: .urlEncoding,
            headers: nil
        )
    }

    override func parseResponse(
        of bankingRequest: GetTransactionHistoryRequest,
        response: Data
    ) throws -> TransactionHistory {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom(ISO8601JSONDateDecodingStrategy)
        let apiTransactions = try jsonDecoder.decode(GustavGetTransactionHistoryRequestResponse.self, from: response)
        let transactions: [Transaction] = try apiTransactions.transactions.map {
            try $0.toTransaction(associating: bankingRequest.bankAccount)
        }

        return TransactionHistory(date: Date(), transactions: transactions)
    }
}
