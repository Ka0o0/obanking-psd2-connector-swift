//
//  DefaultBankServiceProviderConnector.swift
//  OBankingConnector
//
//  Created by Kai Takac on 16.12.17.
//  Copyright © 2017 Kai Takac. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultBankServiceProviderConnector: BankServiceProviderConnector {

    func connectToBankService(
        using connectionInformation: BankServiceConnectionInformation
    ) -> Single<ConnectedBankServiceProvider> {

        if let oAuth2ConnectionInformation = connectionInformation as? OAuth2BankServiceConnectionInformation {

            return Single.just(
                ConnectedOAuth2BankServiceProvider(
                    oAuth2ConnectionInformation: oAuth2ConnectionInformation
                )
            )
        }
        return Single.error(BankServiceProviderConnectorError.unsupportedConnectionInformation)
    }
}
