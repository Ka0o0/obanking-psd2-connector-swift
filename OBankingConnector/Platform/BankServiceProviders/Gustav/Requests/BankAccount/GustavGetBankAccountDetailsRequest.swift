//
//  GustavGetBankAccountDetailsRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 25.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class GustavGetBankAccountDetailsRequest: BankingRequestProcessor<GetBankAccountDetailsRequest> {

    private let url: URL
    private let certificate: Data

    init(baseURL: URL, certificate: Data) {
        url = baseURL.appendingPathComponent("netbanking/my/accounts")
        self.certificate = certificate
    }

    override func perform(
        request: GetBankAccountDetailsRequest,
        using webClient: WebClient
    ) -> Single<BankAccountDetails> {
        let request = makeHTTPRequest(from: request)

        return webClient.request(request, certificate: certificate)
            .filterSuccessfulStatusCodes()
            .map(GustavAccount.self)
            .map { account -> BankAccountDetails in
                guard let details = try account.toBankAccount().details else {
                    throw GustavGetBankAccountDetailsRequestError.insufficientInformationAvailable
                }
                return details
            }
            .asSingle()
    }
}

private extension GustavGetBankAccountDetailsRequest {
    func makeHTTPRequest(from bankingRequest: GetBankAccountDetailsRequest) -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: url.appendingPathComponent(bankingRequest.bankAccount.id),
            parameters: [:],
            encoding: .urlEncoding,
            headers: nil
        )
    }
}

enum GustavGetBankAccountDetailsRequestError: Error {
    case insufficientInformationAvailable
}
