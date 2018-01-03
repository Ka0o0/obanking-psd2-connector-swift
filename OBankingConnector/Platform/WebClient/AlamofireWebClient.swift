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

    private var sessionManagerRetainmentMap: [String: SessionManager] = [:]

    func request(
        _ method: HTTPMethod,
        _ url: URL,
        parameters: [String: Any]?,
        encoding: ParameterEncoding,
        headers: [String: String]?,
        certificate: Data
    ) -> Observable<DataResponse> {

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
            let requestId = retain(sessionManager: sessionManager)

            return sessionManager.rx.responseData(
                alamofireMethod,
                url,
                parameters: parameters,
                encoding: parameterEncoding,
                headers: headers
            )
            .map { DataResponse($0.0, $0.1) }
                .debug()
            .do(
                onNext: { [weak self] _ in
                    self?.release(requestId: requestId)
                },
                onError: { [weak self] _ in
                    self?.release(requestId: requestId)
                }
            )
        } catch let error {
            return Observable.error(error)
        }
    }

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

    deinit {
        print("whasdfs")
    }
}
// swiftlint:enable function_parameter_count

private extension AlamofireWebClient {

    func retain(sessionManager: SessionManager) -> String {
        let requestId = UUID()
        sessionManagerRetainmentMap[requestId.uuidString] = sessionManager
        return requestId.uuidString
    }

    func release(requestId: String) {
        sessionManagerRetainmentMap.removeValue(forKey: requestId)
    }

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
