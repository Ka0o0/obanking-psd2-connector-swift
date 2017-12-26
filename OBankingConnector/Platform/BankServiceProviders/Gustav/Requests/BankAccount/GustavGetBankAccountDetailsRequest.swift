//
//  GustavGetBankAccountDetailsRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 25.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavGetBankAccountDetailsRequest: BankingRequestProcessor<GetBankAccountDetailsRequest> {

    private var url: URL

    init(baseURL: URL) {
        url = baseURL.appendingPathComponent("netbanking/my/accounts")
    }

    override func makeHTTPRequest(from bankingRequest: GetBankAccountDetailsRequest) -> HTTPRequest {
        return HTTPRequest(
            method: .get,
            url: url.appendingPathComponent(bankingRequest.bankAccount.id),
            parameters: [:],
            encoding: .urlEncoding,
            headers: nil
        )
    }

    override func parseResponse(
        of bankingRequest: GetBankAccountDetailsRequest,
        response: Data
    ) throws -> BankAccountDetails {
        let decoder = JSONDecoder()
        let account = try decoder.decode(GustavAccount.self, from: response)

        guard let details = try account.toBankAccount().details else {
            throw GustavGetBankAccountDetailsRequestError.insufficientInformationAvailable
        }

        return details
    }
}

enum GustavGetBankAccountDetailsRequestError: Error {
    case insufficientInformationAvailable
}
