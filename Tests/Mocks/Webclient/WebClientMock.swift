//
//  WebClientMock.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift
@testable import OBankingConnector

final class WebClientMock: WebClient {

    struct Request {
        let method: HTTPMethod
        let url: URL
        let parameters: [String: Any]?
        let encoding: ParameterEncoding
        let headers: [String: String]?
    }

    var lastRequest: Request?
    var shouldSucceed: Bool = true
    var responseData: Data?

    func request(_ method: HTTPMethod,
                 _ url: URL,
                 parameters: [String: Any]?,
                 encoding: ParameterEncoding,
                 headers: [String: String]?)
        -> Observable<DataResponse> {
        lastRequest = Request(method: method, url: url, parameters: parameters, encoding: encoding, headers: headers)

        if shouldSucceed,
            let responseData = self.responseData,
            let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.1", headerFields: nil) {

            return Observable.just(WebClient.DataResponse(urlResponse, responseData))
        }

        return Observable.error(WebClientMockError.failed)
    }
}

enum WebClientMockError: Error {
    case failed
}
