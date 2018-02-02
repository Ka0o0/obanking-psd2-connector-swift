//
//  OAuth2AccessTokenRequestorMock.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift
@testable import OBankingConnector

final class OAuth2AccessTokenRequestorMock: OAuth2AccessTokenRequestor {

    var nextConnectionInformation: OAuth2BankServiceConnectionInformation?

    func requestAccessToken(
        for request: OAuth2AuthorizationRequest,
        authorizationToken: String
    ) -> Single<OAuth2BankServiceConnectionInformation> {
        guard let nextConnectionInformation = self.nextConnectionInformation else {
            return Single.error(OAuth2AccessTokenRequestorMockError.noConnectionInformationProvided)
        }

        return Single.just(nextConnectionInformation)
    }
}

enum OAuth2AccessTokenRequestorMockError: Error {
    case noConnectionInformationProvided
}
