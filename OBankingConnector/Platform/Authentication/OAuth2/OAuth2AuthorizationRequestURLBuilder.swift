//
//  OAuth2AuthorizationRequestURLBuilder.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 13.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation

protocol OAuth2AuthorizationRequestURLBuilder {

    func makeAuthorizationCodeRequestURL(
        for request: OAuth2BankServiceProviderAuthenticationRequest,
        adding state: UUID?
    ) -> URL?
}

final class DefaultOAuth2AuthorizationRequestURLBuilder: OAuth2AuthorizationRequestURLBuilder {
    func makeAuthorizationCodeRequestURL(
        for request: OAuth2BankServiceProviderAuthenticationRequest,
        adding state: UUID?
    ) -> URL? {
        let urlBuilder = URLBuilder(from: request.authorizationEndpointURL)

        urlBuilder.append(queryParameter: ("response_type", "code"))
        urlBuilder.append(queryParameter: ("client_id", request.clientId))

        if let clientSecret = request.clientSecret {
            urlBuilder.append(queryParameter: ("client_secret", clientSecret))
        }

        if let redirectUri = request.redirectURI {
            urlBuilder.append(queryParameter: ("redirect_uri", redirectUri))
        }

        if let scope = request.scope {
            urlBuilder.append(queryParameter: ("scope", scope))
        }

        if let state = state {
            urlBuilder.append(queryParameter: ("state", state.uuidString))
        }

        return urlBuilder.build()
    }
}
