//
//  BankServiceProviderAuthenticationRequestProcessor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

protocol BankServiceProviderAuthenticationRequestProcessor {
    func canProcess(request: BankServiceProviderAuthenticationRequest) -> Bool

    func authenticate(using request: BankServiceProviderAuthenticationRequest)
        -> Single<BankServiceProviderAuthenticationResult>
}
