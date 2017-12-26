//
//  GustavGetBankAccountDetailsRequest.swift
//  OBankingConnector
//
//  Created by Kai Takac on 25.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

final class GustavGetBankAccountDetailsRequest {

    private var url: URL

    init(baseURL: URL) {
        url = baseURL.appendingPathComponent("netbanking/my/accounts")
    }

    func makeHTTPRequest(bankAccountId: String) -> HTTPRequest {

        return HTTPRequest(
            method: .get,
            url: url.appendingPathComponent(bankAccountId),
            parameters: [:],
            encoding: .urlEncoding,
            headers: nil
        )
    }

    func parseResponse(_ data: Data) throws -> BankAccountDetails {
        let decoder = JSONDecoder()
        let account = try decoder.decode(GustavAccount.self, from: data)

        guard let details = try account.toBankAccount().details else {
            throw GustavGetBankAccountDetailsRequestError.insufficientInformationAvailable
        }

        return details
    }
}

enum GustavGetBankAccountDetailsRequestError: Error {
    case insufficientInformationAvailable
}
