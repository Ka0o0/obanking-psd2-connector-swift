//
//  BankServiceProviderAuthorizationProcessor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

protocol BankServiceProviderAuthorizationProcessor {
    func authorize() -> Single<BankServiceProviderAuthenticationResult>
}
