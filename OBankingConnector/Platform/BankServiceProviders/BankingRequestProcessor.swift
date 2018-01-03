//
//  BankingRequestProcessor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 26.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

class BankingRequestProcessor<T> where T: BankingRequest {

    func perform(request: T, using webClient: WebClient) -> Single<T.Result> {
        fatalError("Not implemented")
    }
}
