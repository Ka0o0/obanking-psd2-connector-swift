//
//  OAuth2AuthorizationTokenExtractorMock.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift
@testable import OBankingConnector

final class OAuth2AuthorizationTokenExtractorMock: OAuth2AuthorizationTokenExtractor {

    var nextToken: String?

    func exctract(
        from url: URL,
        considering request: OAuth2BankServiceProviderAuthenticationRequest,
        and state: String?
    ) -> String? {
        return nextToken
    }

    func extract(
        from stream: Observable<URL>,
        considering request: OAuth2BankServiceProviderAuthenticationRequest,
        and state: String?
    ) -> Observable<String> {
        guard let nextToken = self.nextToken else {
            return Observable.error(OAuth2AuthorizationTokenExtractorMockError.noTokenProvided)
        }

        return Observable.just(nextToken)
    }
}

enum OAuth2AuthorizationTokenExtractorMockError: Error {
    case noTokenProvided
}
