//
//  GustavGetTransactionHistoryRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class GustavGetTransactionHistoryRequest: BankingRequestProcessor<GetTransactionHistoryRequest> {

    private let baseURL: URL
    private let certificate: Data

    init(baseURL: URL, certificate: Data) {
        self.baseURL = baseURL
        self.certificate = certificate
    }

    override func perform(
        request: GetTransactionHistoryRequest,
        using webClient: WebClient
    ) -> Single<TransactionHistory> {
        guard let httpRequest = makeHTTPRequest(from: request) else {
            return Single.error(GustavRequestProcessorError.unsupportedAccount)
        }

        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom(ISO8601JSONDateDecodingStrategy)

        return webClient.request(httpRequest, certificate: certificate)
            .filterSuccessfulStatusCodes()
            .map(GustavGetTransactionHistoryRequestResponse.self, using: jsonDecoder)
            .map { apiTransactions -> [Transaction] in
                try apiTransactions.transactions.map {
                    try $0.toTransaction(associating: request.bankAccount)
                }
            }
            .map {
                TransactionHistory(date: Date(), transactions: $0)
            }
            .asSingle()
    }
}

private extension GustavGetTransactionHistoryRequest {
    func makeHTTPRequest(from bankingRequest: GetTransactionHistoryRequest) -> HTTPRequest? {
        guard let sepaAccountNumber = bankingRequest.bankAccount.accountNumber as? SepaAccountNumber else {
            return nil
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
}
