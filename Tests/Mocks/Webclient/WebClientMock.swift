//
//  WebClientMock.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
@testable import OBankingConnector

final class WebClientMock: WebClient {

    struct Request {
        let method: HTTPMethod
        let url: URLConvertible
        let parameters: [String: Any]?
        let encoding: ParameterEncoding
        let headers: [String: String]?
    }

    var lastRequest: Request?
    var shouldSucceed: Bool = true
    var responseDataRequest: DataRequest?

    func request(_ method: Alamofire.HTTPMethod,
                 _ url: URLConvertible,
                 parameters: [String: Any]?,
                 encoding: ParameterEncoding,
                 headers: [String: String]?)
        -> Observable<DataRequest> {
        lastRequest = Request(method: method, url: url, parameters: parameters, encoding: encoding, headers: headers)

        if shouldSucceed,
            let responseDataRequest = self.responseDataRequest {
            return Observable.just(responseDataRequest)
        }

        return Observable.error(WebClientMockError.failed)
    }
}

enum WebClientMockError: Error {
    case failed
}
