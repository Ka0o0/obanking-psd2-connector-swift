//
//  AuthorizationModule.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

public protocol AuthorizationModule {

    func authorize(against bankServiceProvider: BankServiceProvider)
        -> Single<AuthorizationResult>
}
