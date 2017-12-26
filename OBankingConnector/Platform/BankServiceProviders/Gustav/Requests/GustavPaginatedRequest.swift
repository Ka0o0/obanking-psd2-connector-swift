//
//  GustavPaginatedRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavPaginatedRequest<T>: BankingRequestProcessor<PaginatedBankingRequest<T>> where T: BankingRequest {

    private let actualRequestProcessor: BankingRequestProcessor<T>

    init(actualRequestProcessor: BankingRequestProcessor<T>) {
        self.actualRequestProcessor = actualRequestProcessor
    }

    override func makeHTTPRequest(from bankingRequest: PaginatedBankingRequest<T>) throws -> HTTPRequest {
        let httpRequest = try actualRequestProcessor.makeHTTPRequest(from: bankingRequest.request)
        var parameters: [String: Any] = httpRequest.parameters ?? [:]
        parameters["size"] = String(bankingRequest.itemsPerPage)
        parameters["page"] = String(bankingRequest.page)

        return HTTPRequest(
            method: httpRequest.method,
            url: httpRequest.url,
            parameters: parameters,
            encoding: httpRequest.encoding,
            headers: httpRequest.headers
        )
    }

    override func parseResponse(
        of bankingRequest: PaginatedBankingRequest<T>,
        response: Data
    ) throws -> PaginatedBankingRequest<T>.Result {
        let jsonDecoder = JSONDecoder()
        let paginationResult = try jsonDecoder.decode(GustavPaginatedRequestResponse.self, from: response)

        return PaginatedBankingRequest.Result(
            totalPages: paginationResult.pageCount,
            currentPage: paginationResult.pageNumber,
            nextPage: paginationResult.nextPage,
            result: try actualRequestProcessor.parseResponse(of: bankingRequest.request, response: response)
        )
    }
}
