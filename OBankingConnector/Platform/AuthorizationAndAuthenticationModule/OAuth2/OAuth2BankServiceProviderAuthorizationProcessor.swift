//
//  OAuth2BankServiceProviderAuthorizationProcessor.swift
//  OBankingConnector
//
//  Created by Kai Takac on 13.01.18.
//  Copyright © 2018 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class OAuth2BankServiceProviderAuthorizationProcessor: BankServiceProviderAuthorizationProcessor {

    func authorize() -> Single<BankServiceProviderAuthenticationResult> {
        fatalError()
    }
}
