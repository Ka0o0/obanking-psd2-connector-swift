//
//  AlamofireWebClient.swift
//  OBankingConnector
//
//  Created by Kai Takac on 14.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

// swiftlint:disable function_parameter_count
final class AlamofireWebClient: WebClient {

    func request(
        _ method: HTTPMethod,
        _ url: URL,
        parameters: [String: Any]?,
        encoding: ParameterEncoding,
        headers: [String: String]?,
        certificate: Data
    ) -> Observable<WebClient.DataResponse> {

        guard let alamofireMethod = Alamofire.HTTPMethod(rawValue: method.rawValue) else {
            return Observable.error(AlamofireWebClientError.invalidMethod)
        }

        let parameterEncoding: Alamofire.ParameterEncoding
        switch encoding {
        case .json:
            parameterEncoding = JSONEncoding.default
        default:
            parameterEncoding = URLEncoding.default
        }

        do {
            let sessionManager = try createSessionManager(for: url, pinning: certificate)

            return sessionManager.rx.responseData(
                alamofireMethod,
                url,
                parameters: parameters,
                encoding: parameterEncoding,
                headers: headers
            )
            .map { WebClient.DataResponse($0.0, $0.1) }
        } catch let error {
            return Observable.error(error)
        }
    }
}
// swiftlint:enable function_parameter_count

private extension AlamofireWebClient {

    func createSessionManager(for url: URL, pinning certificate: Data) throws -> SessionManager {

        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let host = urlComponents.host else {
            throw AlamofireWebClientError.failedToParseURL
        }

        guard let certificate = SecCertificateCreateWithData(kCFAllocatorDefault, NSData(data: certificate)) else {
            throw AlamofireWebClientError.failedToReadCertificate
        }

        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            host: .pinCertificates(
                certificates: [certificate],
                validateCertificateChain: true,
                validateHost: true
            )
        ]

        return SessionManager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
}

enum AlamofireWebClientError: Error {
    case invalidMethod
    case failedToParseURL
    case failedToReadCertificate
}
