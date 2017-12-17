//
//  ConnectedOAuth2BankServiceProvider.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class ConnectedOAuth2BankServiceProvider: ConnectedBankServiceProvider {

    private let oAuth2ConnectionInformation: OAuth2BankServiceConnectionInformation

    init(oAuth2ConnectionInformation: OAuth2BankServiceConnectionInformation) {
        self.oAuth2ConnectionInformation = oAuth2ConnectionInformation
    }

    func perform<T>(request: T) -> Single<BankingRequestResult<T>> where T: BankingRequest {
        fatalError()
    }
}
