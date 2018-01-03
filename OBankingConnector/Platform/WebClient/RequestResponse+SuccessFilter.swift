//
//  RequestResponse+SuccessFilter.swift
//  OBankingConnector-iOS
//
//  Created by Kai Takac on 03.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType where E == DataResponse {

    func filterSuccessfulStatusCodes() -> Observable<E> {
        return flatMap { response -> Observable<E> in
            guard 200..<300 ~= response.0.statusCode else {
                throw WebClientError.invalidStatusCode
            }

            return Observable.just(response)
        }
    }

    func map<D: Decodable>(_ type: D.Type, using decoder: JSONDecoder = JSONDecoder()) -> Observable<D> {
        return flatMap { response -> Observable<D> in
            return Observable.just(try decoder.decode(D.self, from: response.1))
        }
    }
}
