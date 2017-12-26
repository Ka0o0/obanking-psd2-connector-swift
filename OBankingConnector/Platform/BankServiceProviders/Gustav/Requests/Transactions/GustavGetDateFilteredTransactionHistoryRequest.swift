//
//  GustavGetDateFilteredTransactionHistoryRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

// swiftlint:disable colon
final class GustavGetDateFilteredTransactionHistoryRequest:
    BankingRequestProcessor<GetDateFilteredTransactionHistoryRequest> {

    private var baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    override func makeHTTPRequest(from bankingRequest: GetDateFilteredTransactionHistoryRequest) -> HTTPRequest {
        guard let sepaAccountNumber = bankingRequest.bankAccount.accountNumber as? SepaAccountNumber else {
            fatalError()
        }

        let urlPathAppendix = String(format: "netbanking/cz/my/accounts/%@/transactions", sepaAccountNumber.iban)

        let parameters: [String: String] = [
            "dateStart": bankingRequest.startDate.iso8601,
            "dateEnd": bankingRequest.endDate.iso8601
        ]

        return HTTPRequest(
            method: .get,
            url: baseURL.appendingPathComponent(urlPathAppendix),
            parameters: parameters,
            encoding: .urlEncoding,
            headers: nil
        )
    }

    override func parseResponse(
        of bankingRequest: GetDateFilteredTransactionHistoryRequest,
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
// swiftlint:enable colon
