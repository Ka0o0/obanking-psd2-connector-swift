//
//  WebClient.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

// swiftlint:disable function_parameter_count
protocol WebClient {

    typealias DataResponse = (HTTPURLResponse, Data)

    func request(_ method: HTTPMethod,
                 _ url: URL,
                 parameters: [String: Any]?,
                 encoding: ParameterEncoding,
                 headers: [String: String]?,
                 certificate: Data)
        -> Observable<DataResponse>
}
// swiftlint:enable function_parameter_count

enum WebClientError: Error {
    case invalidStatusCode
}
