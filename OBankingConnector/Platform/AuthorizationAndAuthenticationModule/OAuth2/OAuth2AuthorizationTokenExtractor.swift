//
//  OAuth2AuthorizationTokenExtractor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

protocol OAuth2AuthorizationTokenExtractor {

    func exctract(
        from url: URL,
        considering request: OAuth2BankServiceProviderAuthenticationRequest,
        and state: String?
    ) -> String?

    func extract(
        from stream: Observable<URL>,
        considering request: OAuth2BankServiceProviderAuthenticationRequest,
        and state: String?
    ) -> Observable<String>
}

final class DefaultOAuth2AuthorizationTokenExtractor: OAuth2AuthorizationTokenExtractor {
    func exctract(
        from url: URL,
        considering request: OAuth2BankServiceProviderAuthenticationRequest,
        and state: String?
    ) -> String? {

        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let queryItems = urlComponents.queryItems else {
            return nil
        }

        guard let token = extractParameterValue(from: queryItems, key: "code") else {
            return nil
        }

        if let state = state {
            guard state == extractParameterValue(from: queryItems, key: "state") else {
                return nil
            }
        }

        return token
    }

    func extract(
        from stream: Observable<URL>,
        considering request: OAuth2BankServiceProviderAuthenticationRequest,
        and state: String?
    ) -> Observable<String> {
        return stream
            .flatMapLatest { url -> Observable<String> in
                guard let result = self.exctract(from: url, considering: request, and: state) else {
                    return Observable.never()
                }
                return Observable.just(result)
            }
    }
}

private extension DefaultOAuth2AuthorizationTokenExtractor {

    func extractParameterValue(from queryItems: [URLQueryItem], key: String) -> String? {
        let filtered = queryItems.filter { param in param.name == key }
        return filtered.first?.value
    }
}
