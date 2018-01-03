//
//  CoinbaseGetBankAccountDetailsRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class CoinbaseGetBankAccountDetailsRequest: BankingRequestProcessor<GetBankAccountDetailsRequest> {

    private let baseURL: URL
    private let certificate: Data

    init(baseURL: URL, certificate: Data) {
        self.baseURL = baseURL
        self.certificate = certificate
    }

    override func perform(
        request: GetBankAccountDetailsRequest,
        using webClient: WebClient
    ) -> Single<BankAccountDetails> {
        let httpRequest = makeHTTPRequest(for: request)

        return webClient.request(httpRequest, certificate: certificate)
            .map(CoinbaseGetBankAccountDetailsRequestResponse.self)
            .map { coinbaseAccount -> BankAccountDetails in
                guard let details = try coinbaseAccount.data.toBankAccount().details else {
                    throw CoinbaseGetBankAccountDetailsRequestError.insufficientInformation
                }

                return details
            }
            .asSingle()
    }
}

private extension CoinbaseGetBankAccountDetailsRequest {

    func makeHTTPRequest(for request: GetBankAccountDetailsRequest) -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: baseURL.appendingPathComponent(String(format: "accounts/%@", request.bankAccount.id)),
            parameters: nil,
            encoding: .urlEncoding,
            headers: nil
        )
    }
}

enum CoinbaseGetBankAccountDetailsRequestError: Error {
    case insufficientInformation
}
