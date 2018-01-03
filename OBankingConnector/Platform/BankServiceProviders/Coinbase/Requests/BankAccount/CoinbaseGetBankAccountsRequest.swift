//
//  CoinbaseGetBankAccountsRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class CoinbaseGetBankAccountsRequest: BankingRequestProcessor<GetBankAccountRequest> {

    private let baseURL: URL
    private let certificate: Data

    init(baseURL: URL, certificate: Data) {
        self.baseURL = baseURL
        self.certificate = certificate
    }

    override func perform(
        request: GetBankAccountRequest,
        using webClient: WebClient
    ) -> Single<[BankAccount]> {
        let httpAccountsRequest = makeAccountsHTTPRequest()

        return webClient.request(httpAccountsRequest, certificate: certificate)
            .filterSuccessfulStatusCodes()
            .map(CoinbaseGetBankAccountsRequestResponse.self)
            .map { response -> [BankAccount] in
                try response.data.map { try $0.toBankAccount() }
            }
            .asSingle()
    }
}

private extension CoinbaseGetBankAccountsRequest {
    func makeAccountsHTTPRequest() -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: baseURL.appendingPathComponent("accounts"),
            parameters: nil,
            encoding: .urlEncoding,
            headers: nil
        )
    }
}
