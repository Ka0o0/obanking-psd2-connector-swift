//
//  GustavGetBankAccountsRequest.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 23.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class GustavGetBankAccountsRequest: BankingRequestProcessor<GetBankAccountRequest> {

    private var url: URL
    private var certificate: Data

    init(baseURL: URL, certificate: Data) {
        url = baseURL.appendingPathComponent("netbanking/my/accounts")
        self.certificate = certificate
    }

    override func perform(
        request: GetBankAccountRequest,
        using webClient: WebClient
    ) -> Single<[BankAccount]> {
        let httpRequest = makeHTTPRequest(from: request)

        return webClient.request(httpRequest, certificate: certificate)
            .filterSuccessfulStatusCodes()
            .map(GustavGetBankAccountsRequestResponse.self)
            .map {
                try $0.accounts.map {
                    try $0.toBankAccount()
                }
            }
            .asSingle()
    }
}

private extension GustavGetBankAccountsRequest {
    func makeHTTPRequest(from bankingRequest: GetBankAccountRequest) -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: url,
            parameters: nil,
            encoding: .urlEncoding,
            headers: nil
        )
    }
}

enum GustavGetBankAccountsRequestParseError: Error {
    case unknownCurrency
    case unknownAccountType
    case invalidSepaAccountNumber
}
