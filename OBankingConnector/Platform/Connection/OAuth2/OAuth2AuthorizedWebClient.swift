//
//  OAuth2AuthorizedWebClient.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class OAuth2AuthorizedWebClient: WebClient {

    private let oAuth2ConnectionInformation: OAuth2BankServiceConnectionInformation
    private let webClient: WebClient

    init(
        oAuth2ConnectionInformation: OAuth2BankServiceConnectionInformation,
        webClient: WebClient
    ) {
        self.oAuth2ConnectionInformation = oAuth2ConnectionInformation
        self.webClient = webClient
    }

    // swiftlint:disable function_parameter_count
    func request(
        _ method: HTTPMethod,
        _ url: URL,
        parameters: [String: Any]?,
        encoding: ParameterEncoding,
        headers: [String: String]?,
        certificate: Data
    ) -> Observable<DataResponse> {
        var headersWithAuth = headers ?? [:]
        headersWithAuth["Authorization"] = String(
            format: "%@ %@",
            oAuth2ConnectionInformation.tokenType,
            oAuth2ConnectionInformation.accessToken
        )

        return webClient.request(
            method,
            url,
            parameters: parameters,
            encoding: encoding,
            headers: headersWithAuth,
            certificate: certificate
        )
    }
    // swiftlint:enable function_parameter_count

    func request(_ request: HTTPRequest, certificate: Data) -> Observable<DataResponse> {
        return self.request(
            request.method,
            request.url,
            parameters: request.parameters,
            encoding: request.encoding,
            headers: request.headers,
            certificate: certificate
        )
    }

}
