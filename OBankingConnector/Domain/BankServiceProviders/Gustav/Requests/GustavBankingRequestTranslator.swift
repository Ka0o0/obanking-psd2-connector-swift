//
//  GustavBankingRequestTranslator.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 21.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavBankingRequestTranslator: BankingRequestTranslator {

    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func makeHTTPRequest<T>(from bankingRequest: T) -> HTTPRequest? where T: BankingRequest {

        if bankingRequest is GetBankAccountRequest {
            return GustavGetBankAccountsRequest(baseURL: baseURL)
                .makeHTTPRequest()
        }

        if let request = bankingRequest as? PaginatedBankingRequest<GetBankAccountRequest> {
            return GustavGetBankAccountsRequest(baseURL: baseURL)
                .makeHTTPRequest(pageSize: request.itemsPerPage, page: request.page)
        }

        if let request = bankingRequest as? GetBankAccountDetailsRequest {
            return GustavGetBankAccountDetailsRequest(baseURL: baseURL)
                .makeHTTPRequest(bankAccountId: request.bankAccount.id)
        }

        if let request = bankingRequest as? GetTransactionHistoryRequest,
            let sepaAccountNumber = request.bankAccount.accountNumber as? SepaAccountNumber {
            return GustavGetTransactionHistoryRequest(baseURL: baseURL)
                .makeHTTPRequest(iban: sepaAccountNumber.iban)
        }

        return nil
    }

    // swiftlint:disable force_cast
    func parseResponse<T>(of bankingRequest: T, response: Data) throws -> T.Result where T: BankingRequest {

        if bankingRequest is GetBankAccountRequest {
            return try GustavGetBankAccountsRequest(baseURL: baseURL)
                .parseResponse(response) as! T.Result
        }

        if bankingRequest is GetBankAccountDetailsRequest {
            return try GustavGetBankAccountDetailsRequest(baseURL: baseURL)
                .parseResponse(response) as! T.Result
        }

        if let request = bankingRequest as? GetTransactionHistoryRequest {
            return try GustavGetTransactionHistoryRequest(baseURL: baseURL)
                .parseResponse(response, bankAccount: request.bankAccount) as! T.Result
        }

        throw BankingRequestTranslatorError.unsupportedRequestType
    }
    // swiftlint:enable force_cast
}
