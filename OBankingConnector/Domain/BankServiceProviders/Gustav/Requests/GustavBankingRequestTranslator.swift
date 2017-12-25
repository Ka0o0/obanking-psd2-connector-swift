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

        return nil
    }

    func parseResponse<T>(of bankingRequest: T, response: Data) throws -> T.Result where T: BankingRequest {
        throw BankingRequestTranslatorError.unsupportedRequestType
    }
}