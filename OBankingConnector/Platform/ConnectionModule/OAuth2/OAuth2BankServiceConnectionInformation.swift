//
//  OAuth2BankServiceConnectionInformation.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

struct OAuth2BankServiceConnectionInformation: BankServiceConnectionInformation, Codable {

    private enum CodingKeys: String, CodingKey {
        case bankServiceProviderId
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expirationDate
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
    }

    let bankServiceProviderId: String
    let accessToken: String
    let tokenType: String
    let expiresIn: Double?
    let expirationDate: Date?
    let refreshToken: String?
    let scope: String?

    init(
        bankServiceProviderId: String,
        accessToken: String,
        tokenType: String,
        expirationDate: Date? = nil,
        refreshToken: String? = nil,
        scope: String? = nil
    ) {
        self.bankServiceProviderId = bankServiceProviderId
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expirationDate?.timeIntervalSinceNow
        self.expirationDate = expirationDate
        self.refreshToken = refreshToken
        self.scope = scope
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        bankServiceProviderId = try container.decodeIfPresent(String.self, forKey: .bankServiceProviderId) ?? "unknown"
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)

        if  let expiresIn = try container.decodeIfPresent(Double.self, forKey: .expiresIn) {
            self.expiresIn = expiresIn
            expirationDate = Date(timeIntervalSinceNow: expiresIn)
        } else {
            expiresIn = nil
            expirationDate = nil
        }
    }
}
