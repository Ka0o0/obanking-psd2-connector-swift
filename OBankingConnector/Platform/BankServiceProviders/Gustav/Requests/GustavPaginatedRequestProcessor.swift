//
//  GustavPaginatedRequestProcessor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class GustavPaginatedRequestProcessor<T>:
    BankingRequestProcessor<PaginatedBankingRequest<T>> where T: BankingRequest {

    private let actualRequestProcessor: BankingRequestProcessor<T>

    init(actualRequestProcessor: BankingRequestProcessor<T>) {
        self.actualRequestProcessor = actualRequestProcessor
    }

    override func perform(
        request: PaginatedBankingRequest<T>,
        using webClient: WebClient
    ) -> Single<PaginatedBankingRequest<T>.Result> {
        let bufferingWebClient = BufferingPaginatedWebClient(
            page: request.page,
            size: request.itemsPerPage,
            webClient: webClient
        )

        return actualRequestProcessor.perform(request: request.request, using: bufferingWebClient)
            .map { actualResult -> PaginatedBankingRequest<T>.Result in
                guard let dataResponse = bufferingWebClient.lastRequestResponse,
                    let paginationInformation = try? self.extractPaginationInformation(from: dataResponse)
                else {
                    throw GustavPaginatedRequestProcessorError.missingResponseData
                }

                return PaginatedBankingRequest<T>.Result(
                    totalPages: paginationInformation.pageCount,
                    currentPage: paginationInformation.pageNumber,
                    nextPage: paginationInformation.nextPage,
                    result: actualResult
                )
            }
    }
}

private extension GustavPaginatedRequestProcessor {

    class BufferingPaginatedWebClient: WebClient {

        var lastRequestResponse: DataResponse?

        private let page: Int
        private let size: Int
        private let webClient: WebClient

        init(
            page: Int,
            size: Int,
            webClient: WebClient
        ) {
            self.page = page
            self.size = size
            self.webClient = webClient
        }

        // swiftlint:disable function_parameter_count
        func request(
            _ method: HTTPMethod,
            _ url: URL,
            parameters: [String: Any]?,
            encoding: ParameterEncoding,
            headers: [String: String]?,
            certificate: Data
        ) -> Observable<DataResponse> {
            var parametersWithPaginationInformation = parameters ?? [:]
            parametersWithPaginationInformation["page"] = String(page)
            parametersWithPaginationInformation["size"] = String(size)

            return webClient.request(
                method,
                url,
                parameters: parametersWithPaginationInformation,
                encoding: encoding,
                headers: headers,
                certificate: certificate
            ).do(onNext: { [weak self] response in
                self?.lastRequestResponse = response
            })
        }
        // swiftlint:enable function_parameter_count

        func request(_ request: HTTPRequest, certificate: Data) -> Observable<DataResponse> {
            return self.request(
                request.method,
                request.url,
                parameters: request.parameters,
                encoding: request.encoding,
                headers: request.headers,
                certificate: certificate
            )
        }
    }

    func extractPaginationInformation(
        from requestResponse: DataResponse
    ) throws -> GustavPaginatedRequestResponse {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(GustavPaginatedRequestResponse.self, from: requestResponse.1)
    }
}

enum GustavPaginatedRequestProcessorError: Error {
    case missingResponseData
}
