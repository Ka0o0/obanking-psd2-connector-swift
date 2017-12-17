//
//  BankServiceProviderConnector.swift
//  OBankingConnector
//
//  Created by Kai Takac on 12.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

public protocol BankServiceProviderConnector {

    func connectToBankService(using connectionInformation: BankServiceConnectionInformation)
        -> Single<ConnectedBankServiceProvider>
}

enum BankServiceProviderConnectorError: Error {
    case unsupportedConnectionInformation
    case connectionError
}
