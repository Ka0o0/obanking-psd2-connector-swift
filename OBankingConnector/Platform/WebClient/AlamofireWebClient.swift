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

final class AlamofireWebClient: WebClient {

    func request(
        _ method: HTTPMethod,
        _ url: URL,
        parameters: [String: Any]?,
        encoding: ParameterEncoding,
        headers: [String: String]?
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

        return RxAlamofire.requestData(
            alamofireMethod, url,
            parameters: parameters,
            encoding: parameterEncoding,
            headers: headers
        )
        .map { WebClient.DataResponse($0.0, $0.1) }
    }
}

enum AlamofireWebClientError: Error {
    case invalidMethod
}
